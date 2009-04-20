From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: LSF: Multipathing and path checking question
Date: Mon, 20 Apr 2009 18:02:39 -0500
Message-ID: <49ECFF0F.5080003@cs.wisc.edu>
References: <49E7B845.70400@cs.wisc.edu>
	<49E834CD.1090306@suse.de>	<49E89866.50205@cs.wisc.edu>
	<49E89E92.7070709@cs.wisc.edu>	<49EC3010.5050502@suse.de>
	<49ECCBAC.70308@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49ECCBAC.70308@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
>> For starters we just should send a netlink event when fast_fail_io has
>> fired. We could easily integrate that one in multipathd and would gain
>> an instant benefit from that as we can switch paths in advance.
>> Next step would be to implement an additional sdev state which would
>> return 'DID_TRANSPORT_FASTFAIL' for any 'normal' I/O; it would be
>> inserted between 'RUNNING' and 'CANCEL'.
>> Transition would be possible between 'RUNNING' and 'FASTFAIL', but
>> it would only be possible to transition into 'CANCEL' from 'FASTFAIL'.
>>
> 
> 
> Yeah, a new sdev state might be nice. Right now this state is handled by 
> the classes. For iscsi and FC the port/session will be in 
> blocked/ISCSI_SESSION_FAILED. Then internally the classes are decieding 
> what to do with IO in the *_chkready functions.
> 
> 


How about setting the device to the offline state for this case where 
fast_io_fail has fired but the dev_loss_tmo has not yet fired? As fast 
as failing IO we get the same result. scsi-ml would fail the incoming IO 
instead of it getting to the class _chkready functions, but the scsi 
device state indicates that it cannot execute IO which might be nice for 
users.

Can we not do this because offline for the device only means when the 
scsi-eh has put it offline because it could not recover it or is it more 
generic like for any time it cannot execute IO?
