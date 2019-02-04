From: Laura Abbott <labbott@redhat.com>
Subject: Re: Userspace regression with 6baca7601bde ("scsi: target: drop
 unused pi_prot_format attribute storage")
Date: Mon, 4 Feb 2019 06:58:49 +0100
Message-ID: <b03a25f0-ea67-3e1b-ffc7-3d9b9f6e838e@redhat.com>
References: <57120b72-2ab9-bfa5-f69c-31aee78d5936@redhat.com>
 <20190204014048.1cf91326@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190204014048.1cf91326@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Disseldorp <ddiss@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 2/4/19 1:40 AM, David Disseldorp wrote:
> Hi Laura,
> 
> Thanks for the report...
> 
> On Sun, 3 Feb 2019 17:56:00 +0100, Laura Abbott wrote:
> 
>> Fedora got a bug report of a new permission denied error with 5.0-rc2:
>>
>>>    File "/usr/lib/python3.7/site-packages/rtslib_fb/utils.py", line 100, in fread
>>>      with open(path, 'r') as file_fd:
>>> PermissionError: [Errno 13] Permission denied: '/sys/kernel/config/target/core/fileio_28/xxx/attrib/pi_prot_format'
>>
>> This looks like an intentional behavior change with
>>
>> commit 6baca7601bdee2e57f20c45d63eb53b89b33e816
>> Author: David Disseldorp <ddiss@suse.de>
>> Date:   Fri Nov 23 18:36:11 2018 +0100
>>
>>       scsi: target: drop unused pi_prot_format attribute storage
>>       
>>       On write, the pi_prot_format configfs attribute invokes the device
>>       format_prot() callback if present. Read dumps the contents of
>>       se_dev_attrib.pi_prot_format which is always zero.  Make the configfs
>>       attribute write-only, and drop the always zero se_dev_attrib.pi_prot_format
>>       storage.
>>       
>>       Signed-off-by: David Disseldorp <ddiss@suse.de>
>>       Reviewed-by: Christoph Hellwig <hch@lst.de>
>>       Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>
>>
>> Unfortunately, existing code that's opening with read permissions is now broken.
>> Can this be reverted? Full bug at https://bugzilla.redhat.com/show_bug.cgi?id=1667505
> 
> Lee (cc'ed) pinged me a couple of days ago about the same issue.
> My preference would be to add back a dummy read handler without the
> corresponding (unused) se_dev_attrib.pi_prot_format member.
> I'll prepare something tomorrow with this, but if it's urgent then I'd
> also be okay with a straight revert.
> 
> Cheers, David
> 

A fix is fine by me. Thanks for the prompt response.

Thanks,
Laura
