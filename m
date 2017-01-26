From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH v2 0/2] scsi: storvsc: Add support for FC lightweight host.
Date: Thu, 26 Jan 2017 08:38:58 -0500
Message-ID: <1485437940-18706-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@microsoft.com, hch@infradead.org, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: devel@linuxdriverproject.org, famz@redhat.com, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch set is based on the following patch submission
and email exchange:

[PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on Hyper-V
K. Y. Srinivasan kys at microsoft.com
Sat Mar 12 21:52:48 UTC 2016

http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2016-March/087116.html

Included in the current storvsc driver for Hyper-V is the ability
to access luns on an FC fabric via a virtualized fiber channel
adapter exposed by the Hyper-V host. This was done to provide an
interface for existing customer tools that was more consistent with
a conventional FC device. The driver attaches to the FC transport 
to allow host and port names to be published under 
/sys/class/fc_host/hostX.

A problem arose when attaching to the FC transport. The scsi_scan code
attempts to call fc_user_scan which has basically become a no-op 
due to the virtualized nature of the FC host 
( missing rports, vports, etc ). At this point you cannot refresh
the scsi bus after mapping or unmapping luns on the SAN without
a reboot.

The patch above attempted to address the problem of not being
able to scan FC hosts on a Hyper-V guest by setting
fc_transport_template->user_scan = NULL but it was rejected
in favor of a new "lightweight" version of the FC transport that
only provides the bare minimum functionality of the standard FC model.
This new transport option would be more suitable for FC transports
running on a VM and provide some flexibility in the future.

The patches below offer a method to incorporate the new 
lightweight FC option into the existing transport
and storvsc drivers.

Patch 1: scsi_transport_fc.h, scsi_transport_fc.c

1) Adds the lightweight_transport option to fc_function_template.
Based on this selection the transport will either be lightweight
or default to heavyweight.

2) Divides the applicable export functions into two sets.
The lightweight functions involve FC attributes port_name and 
node name. The functions that deal with targets, rports, etc
are not used. The heavyweight default contains the original
standard physical FC hba attribute set. 

3) All top level FC class directories such fc_remote_ports,
fc_transport, and fc_vports are still created when the transport
driver is loaded. They are just not populated when running in
lightweight mode. Conceptually both lightweight and heavyweight
clients could coexist.

4) fc_transport_template->user_scan is now null and the bus 
can be scanned.

Patch 2: storvsc.c

1) storvsc elects to use the new lightweight FC host option 
by enabling it in fc_function_template. 

2) Removes an original workaround dealing with replacing
the eh_timed_out function. Patch 1 will not set the 
scsi_transport_template.eh_timed_out function directly during
lightweight fc_attach_transport(). It instead relies on
whatever was indicated as the scsi_host_template timeout handler
during scsi_times_out() scsi_error.c. So the workaround is 
no longer necessary.


It has been suggested that the word lightweight may not be
the best choice of terms when describing the new FC transport
option.  I can offer a few new ones but I am not particularly
imaginative. 

Virtual FC
Mini FC
Host only FC 


Changes from V1:

Added more comments and documentation in the code regarding 
the lightweight feature.


Cathy Avery (2):
  scsi: scsi_transport_fc: Provide a lightweight option for Virtual FC
    Hosts.
  scsi: storvsc: Add support for FC lightweight host.

 drivers/scsi/scsi_transport_fc.c | 144 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/storvsc_drv.c       |  12 ++--
 include/scsi/scsi_transport_fc.h |   2 +
 3 files changed, 149 insertions(+), 9 deletions(-)

-- 
2.5.0
