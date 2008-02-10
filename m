From: Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH 11/9 update] firewire: fw-sbp2: enforce a retry of
	__scsi_add_device if bus generation changed
Date: Sun, 10 Feb 2008 13:36:57 -0500
Message-ID: <200802101336.57689.jwilson@redhat.com>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
	<47ACB449.3060200@s5r6.in-berlin.de>
	<tkrat.e02d667ba3320993@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.e02d667ba3320993@s5r6.in-berlin.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 08 February 2008 04:33:29 pm Stefan Richter wrote:
> fw-sbp2 is unable to reconnect while performing __scsi_add_device
> because there is only a single workqueue thread context available for
> both at the moment.  This should be fixed eventually.
>
> An actual failure of __scsi_add_device is easy to handle, but an
> incomplete execution of __scsi_add_device with an sdev returned would
> remain undetected and leave the SBP-2 target unusable.
>
> Therefore we use a workaround:  If there was a bus reset during
> __scsi_add_device (i.e. during the SCSI probe), we remove the new sdev
> immediately, log out, and attempt login and SCSI probe again.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Now *this* does the trick. I get the 'READ CAPACITY failed' as before, 
then 'firewire_sbp2: fw1.0: error status: 0:4', followed by a new login and 
SCSI probe, both of which are successful this time, disk is available for use 
and all that good stuff.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
