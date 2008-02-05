From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Tue, 05 Feb 2008 14:04:26 -0600
Message-ID: <47A8C14A.3030207@cs.wisc.edu>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>	
	<20080124003203.18871.52040.sendpatchset@localhost.localdomain>	
	<1202151498.3096.84.camel@localhost.localdomain>	
	<1202156151.13537.14.camel@linuxchandra>
	<1202156914.3096.112.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1202156914.3096.112.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@us.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-02-04 at 12:15 -0800, Chandra Seetharaman wrote:
>> On Mon, 2008-02-04 at 12:58 -0600, James Bottomley wrote:
>>> On Wed, 2008-01-23 at 16:32 -0800, Chandra Seetharaman wrote:
>>>> Subject: scsi_dh: Add support for SDEV_PASSIVE
>>>>
>>>> From: Chandra Seetharaman <sekharan@us.ibm.com>
>>>>
>>>> This patch adds a new device state SDEV_PASSIVE, to correspond to the
>>>> passive side access of an active/passive multipathed device.
>>> Really, no; this isn't right.  The state field of a SCSI device is for
>>> the SCSI state model.  Passive might be a valid device mapper state, but
>> Hi James,
>>
>> It is not the "device mapper state", it is the state of the device
>> itself. These devices have active/passive paths, the passive paths will
>> be represented by SDEV_PASSIVE device state in SCSI.
> 
> Yes, it is .. you're killing commands on the basis of being in this
> state, which nothing in SCSI ever sets.

SCSI does set this. See below.

> 
> A proper return from a passive path is the SCSI standard NOT_READY
> LOGICAL UNIT NOT READY, INITIALIZING COMMAND REQUIRED.  We expect to see
> this, not the command being killed.
> 

I think this part of the patch is trying to implement and detect the 
Target port asymetric access states from spc3 section 5.8.2.4 (it does 
not follow it exactly because devices like RDAC or old clarrions did not 
implement the spec), and then use that info to fail commands before they 
are even sent to the device to avoid start up delays from when programs 
like udev, hal, kernel partition scanning probe the device.

For the LSI patch it works like the following:

When IO is sent to a path that cannot execute IO optimally, the scsi hw 
handler hook for sense processing (see rdac_check_sense in "[PATCH 8/9] 
scsi_dh: add lsi rdac device handler" and the scsi_error.c hook in in 
"scsi_dh: add skeleton for SCSI Device Handlers") will detect this and 
set the state to passive so future IO is not execute on the path 
(SG_IO/passthrough is allowed).

I am not sure about alternatives. If we just exported the port access 
state in sysfs, but did not fail IO from scsi_prep_state_check, then the 
users could still check the state before sending IO. Would it be 
horrible to convert apps to do this?
