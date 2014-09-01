From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Mon, 01 Sep 2014 15:52:10 -0400
Message-ID: <5404CE6A.8090402@interlog.com>
References: <5403AB47.3040706@interlog.com> <20140901153629.GA29938@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140901153629.GA29938@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 14-09-01 11:36 AM, Christoph Hellwig wrote:
>> --- a/drivers/scsi/scsi_debug.c	2014-08-26 13:24:51.646948507 -0400
>> +++ b/drivers/scsi/scsi_debug.c	2014-08-30 18:04:54.589226679 -0400
>> @@ -2743,6 +2743,13 @@ static int stop_queued_cmnd(struct scsi_
>>   		if (test_bit(k, queued_in_use_bm)) {
>>   			sqcp = &queued_arr[k];
>>   			if (cmnd == sqcp->a_cmnd) {
>> +				devip = (struct sdebug_dev_info *)
>> +					cmnd->device->hostdata;
>> +				if (devip)
>> +					atomic_dec(&devip->num_in_q);
>> +				sqcp->a_cmnd = NULL;
>
> Why would the hostdata every be NULL here?  We should never
> call ->slave_destroy on a device that has outstanding commands.

To your first question, perhaps it could not be. In
the scsi_debug driver almost all uses of 'devip'
check for NULL, so it may not always have been true.

'rmmod scsi_debug' would lead to scsi_debug_exit()
being called and that called stop_all_queued() which
deadlocked with a command completion, or worse command
commencement. scsi_debug_exit() looks a bit racy: the
first thing it does is stop_all_queued() but has
anything been done to stop new commands being issued?
Later scsi_debug_exit() brings down the hosts.


This patch is primarily a bug fix for the lk 3.17 series and
the code you highlight was simply moved from being under a
lock to outside that lock. I didn't want to be too creative,
it's too easy to slip up and upset the management.


Enhancements could be sent to your drivers-for-3.18 tree. Rob
Elliott already has a few in mind, to improve performance.
Removing all 'devip' NULL checks would also improve performance,
and readability.

Doug Gilbert
