From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] scsi: require CAP_SYS_ADMIN to write to procfs interface
Date: Sun, 5 Nov 2017 07:26:51 +1100
Message-ID: <8769e150-db7b-b020-66e6-7f5e9c102977@suse.de>
References: <20171104185913.10658-1-asarai@suse.de>
	<7595538b-c203-0af4-810e-e3f97334a314@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <7595538b-c203-0af4-810e-e3f97334a314-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>> Previously, the only capability effectively required to operate on the
>> /proc/scsi interface was CAP_DAC_OVERRIDE (or for some other files,
>> having an fsuid of GLOBAL_ROOT_UID was enough). This means that
>> semi-privileged processes could interfere with core components of a
>> system (such as causing a DoS by removing the underlying SCSI device of
>> the host's / mount).
>>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
>> ---
>>   drivers/scsi/scsi_proc.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
>> index 480a597b3877..486aedce2f05 100644
>> --- a/drivers/scsi/scsi_proc.c
>> +++ b/drivers/scsi/scsi_proc.c
>> @@ -51,7 +51,10 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
>>   	struct Scsi_Host *shost = PDE_DATA(file_inode(file));
>>   	ssize_t ret = -ENOMEM;
>>   	char *page;
>> -
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM
> 
> did that build without a trailing ';' ?

D'oh. Re-sent, thanks.

-- 
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
