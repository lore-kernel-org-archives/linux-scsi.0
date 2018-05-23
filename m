From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 6/6] scsi: Check sense buffer size at build time
Date: Wed, 23 May 2018 14:08:19 -0700
Message-ID: <CAGXu5jLonX60J2LFPk95=tdx-+zSdaV3y6CTGk6R=-DP-X0sWg@mail.gmail.com>
References: <20180522181512.39316-1-keescook@chromium.org> <20180522181512.39316-7-keescook@chromium.org>
 <7de525d4-52f4-80f2-1f55-a3a5c37d7bf9@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7de525d4-52f4-80f2-1f55-a3a5c37d7bf9@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2018 at 1:25 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello!
>
> On 5/22/2018 9:15 PM, Kees Cook wrote:
>
>> To avoid introducing problems like those fixed in commit f7068114d45e
>> ("sr: pass down correctly sized SCSI sense buffer"), this creates a macro
>> wrapper for scsi_execute() that verifies the size of the sense buffer
>> similar to what was done for command string sizes in commit 3756f6401c30
>> ("exec: avoid gcc-8 warning for get_task_comm").
>>
>> Another solution could be to add another argument to scsi_execute(),
>> but this function already takes a lot of arguments and Jens was not fond
>> of that approach. As there was only a pair of dynamically allocated sense
>> buffers, this also moves those 96 bytes onto the stack to avoid triggering
>> the sizeof() check.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>   drivers/scsi/scsi_lib.c    |  6 +++---
>>   include/scsi/scsi_device.h | 12 +++++++++++-
>>   2 files changed, 14 insertions(+), 4 deletions(-)
>>
> [...]
>>
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 7ae177c8e399..1bb87b6c0ad2 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -426,11 +426,21 @@ extern const char *scsi_device_state_name(enum
>> scsi_device_state);
>>   extern int scsi_is_sdev_device(const struct device *);
>>   extern int scsi_is_target_device(const struct device *);
>>   extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
>> -extern int scsi_execute(struct scsi_device *sdev, const unsigned char
>> *cmd,
>> +extern int __scsi_execute(struct scsi_device *sdev, const unsigned char
>> *cmd,
>>                         int data_direction, void *buffer, unsigned
>> bufflen,
>>                         unsigned char *sense, struct scsi_sense_hdr
>> *sshdr,
>>                         int timeout, int retries, u64 flags,
>>                         req_flags_t rq_flags, int *resid);
>> +/* Make sure any sense buffer is the correct size. */
>> +#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,
>> \
>> +                    sshdr, timeout, retries, flags, rq_flags, resid)   \
>> +({                                                                     \
>> +       BUILD_BUG_ON((sense) != NULL &&                                 \
>> +                    sizeof(sense) != SCSI_SENSE_BUFFERSIZE);           \
>
>
>    This would only check the size of the 'sense' pointer, no?

Correct. Passing in a variable that was declared as:

char sense[SCSI_SENSE_BUFFERSIZE];

would pass this check. Dynamically allocated would not (and we don't
have any cases of that left after the prior patch in this series), and
it should cast improper casts.

If people don't like this bit of robustness vs complexity/limit, I'm
happy to leave it off the series.

-Kees

-- 
Kees Cook
Pixel Security
