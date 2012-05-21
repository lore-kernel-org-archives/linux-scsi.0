From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 1/5] st: Use static class attributes
Date: Mon, 21 May 2012 16:04:52 -0700
Message-ID: <4FBACA14.5090804@suse.com>
References: <4FB476DD.4020107@suse.com> <20120518025146.GB19158@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120518025146.GB19158@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
List-Id: linux-scsi@vger.kernel.org

Jeff would normally reply to this, since it is his patch, but he is
otherwise occupied right now, so I will respond.

On 05/17/2012 07:51 PM, Matthew Wilcox wrote:
> On Wed, May 16, 2012 at 08:56:13PM -0700, Lee Duncan wrote:
>> @@ -84,7 +84,8 @@ static int try_wdio = 1;
>>  static int st_dev_max;
>>  static int st_nr_dev;
>>  
>> -static struct class *st_sysfs_class;
>> +extern struct class st_sysfs_class;
> 
> Umm ... 'extern' ...
> 
>> @@ -4283,6 +4284,11 @@ static void scsi_tape_release(struct kref *kref)
>>  	return;
>>  }
>>  
>> +struct class st_sysfs_class = {
>> +	.name = "scsi_tape",
>> +	.dev_attrs = st_dev_attrs,
>> +};
> 
> ... and then you define it?
> 
> I think you meant to say "struct class st_sysfs_class;" at the top,
> and then later:
> 
> static struct class st_sysfs_class = {
> ...
> 
>> +struct device_attribute st_dev_attrs[] = {
> 
> Should also be static
> 
> 

The compiler (gcc 4.6.2) does not accept a forward declaration that does
not match the data definition. When I tried your suggestion, the
compiler complained that the two declarations did not match, but it
accepted it if both the forward declaration and the data declaration are
"static".

I'll resubmit v3 of the patch set with this change.
-- 
Lee Duncan
SUSE Labs
