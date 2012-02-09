From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] SCSI, st: modify tape driver to allow writing immediate
 filemarks
Date: Thu, 09 Feb 2012 09:22:39 -0800
Message-ID: <4F3400DF.9080603@suse.com>
References: <4F31CAC0.3010905@suse.com> <1328663723.27428.2.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328663723.27428.2.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Joe:

Thanks for the quick review.

On 02/07/2012 05:15 PM, Joe Perches wrote:
> On Tue, 2012-02-07 at 17:07 -0800, Lee Duncan wrote:
>> Add an st module option st_nowait_eof which defaults to 0. Setting this
>> option to 1 tells the st driver not to wait when writing a filemark, which
>> can result in much faster times on streaming tape drives.
> 
> trivial comments:
> 
>> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> []
>> @@ -81,6 +81,7 @@ static int max_sg_segs;
>>  static int try_direct_io = TRY_DIRECT_IO;
>>  static int try_rdio = 1;
>>  static int try_wdio = 1;
>> +static int st_nowait_eof = 0;
> 
> Could be bool.

In both this case and the one you site below, the existing variables are
not bool. I'd rather see new variables match existing variables, in
naming, type, and usage. Next major update of the driver, I'd like to
see all of these bools-in-use fixed.

> 
>> @@ -1106,6 +1109,11 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
>>                                      STp->drv_buffer));
>>  		}
>>  		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
>> +		if (!STp->drv_buffer && STp->immediate_filemark) {
>> +			printk(KERN_WARNING "%s: non-buffered tape: "
>> +			    "disabling writing immediate filemarks", name);
> 
> Needs terminating "\n" and it's better to coalesce the
> format and ignore 80 char lines to make arbitrary greps
> a bit easier.

Good catch. Thanks.

-- 
Lee Duncan
