From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 14/27] drivers/scsi: Use memdup_user
Date: Sun, 23 May 2010 18:36:41 +0300
Message-ID: <4BF94B89.2050101@panasas.com>
References: <Pine.LNX.4.64.1005221022180.13021@ask.diku.dk> <1274538263.4410.38.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:43126 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752232Ab0EWPgp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2010 11:36:45 -0400
In-Reply-To: <1274538263.4410.38.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Julia Lawall <julia@diku.dk>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 05/22/2010 05:24 PM, James Bottomley wrote:
> On Sat, 2010-05-22 at 10:22 +0200, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Use memdup_user when user data is immediately copied into the
>> allocated region.
>>
>> The semantic patch that makes this change is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression from,to,size,flag;
>> position p;
>> identifier l1,l2;
>> @@
>>
>> -  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
>> +  to = memdup_user(from,size);
>>    if (
>> -      to==NULL
>> +      IS_ERR(to)
>>                  || ...) {
>>    <+... when != goto l1;
>> -  -ENOMEM
>> +  PTR_ERR(to)
>>    ...+>
>>    }
>> -  if (copy_from_user(to, from, size) != 0) {
>> -    <+... when != goto l2;
>> -    -EFAULT
>> -    ...+>
>> -  }
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> ---
>>  drivers/scsi/sg.c |   11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index ef752b2..277ace6 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -1676,14 +1676,9 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
>>  		int len, size = sizeof(struct sg_iovec) * iov_count;
>>  		struct iovec *iov;
>>  
>> -		iov = kmalloc(size, GFP_ATOMIC);
>> -		if (!iov)
>> -			return -ENOMEM;
>> -
>> -		if (copy_from_user(iov, hp->dxferp, size)) {
>> -			kfree(iov);
>> -			return -EFAULT;
>> -		}
>> +		iov = memdup_user(hp->dxferp, size);
>> +		if (IS_ERR(iov))
>> +			return PTR_ERR(iov);
> 
> This type of transformation has really no value at all.  The code you're
> proposing to replace is already correct.  I'm fairly ambivalent on
> patterned APIs anyway but I accept they're useful way to prevent new
> code getting it wrong. However, it's completely bogus to force
> replacement of correctly functioning code throughout the kernel (unless
> you're going to argue that everyone who tries to copy from user into a
> kmalloc space does a cut and paste from sg?)
> 
> Of infinitely greater service would be finding any places where the
> pattern is being incorrectly used.
> 

It looks like it is not done 100% kosher and calling memdup_user should
be better.

- For 1 memdup_user does a GFP_KERNEL with a comment on how copy_from_user
  would eventually sleep, so what's the point of GFP_ATOMIC?
  If this is by design then it surly calls for a comment that explains.
  (I would like to know)

- 2nd kmalloc_track_caller is called which is more appropriate here by
  a small margin, No?

Just my $0.017
Boaz

> So, if Doug wants to take this as a prettify of sg, I'm happy, but if
> not, I don't really want to see this again.
> 
> Thanks,
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

