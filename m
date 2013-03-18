From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] [SCSI]: print the msgbytes and statusbyte from scsi result
Date: Mon, 18 Mar 2013 20:57:38 +0900
Message-ID: <CAKYAXd-thiuWagZPf8825=eKLQPyx3w+h5vzKXn_O_g7n9CpDg@mail.gmail.com>
References: <1363508951-3011-1-git-send-email-linkinjeon@gmail.com>
	<1363601689.2412.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1363601689.2412.12.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

2013/3/18, James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Sun, 2013-03-17 at 17:29 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Introduce msgbyte and statusbyte in the prints as part of the
>> result which is returned by the lower layer driver in response to
>> SCSI command issued, in case of any error conditions.
>>
>> Purpose of adding these prints is to convey, during any I/O
>> error case, which condition exactly has happened in lower device and
>> from the prints we can directly deduce, what is the status of comman=
d
>> issued. This will help to quickly debug the scenario and also making
>> a test case to create new scenarios.
>>
>> Also change the printk to more appropriate pr_* macro.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  drivers/scsi/constants.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 76e4c03..77bb1dc 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1445,8 +1445,10 @@ void scsi_show_result(int result)
>>
>>  void scsi_show_result(int result)
>>  {
>> -	printk("Result: hostbyte=3D0x%02x driverbyte=3D0x%02x\n",
>> -	       host_byte(result), driver_byte(result));
>> +	pr_info("Result: hostbyte=3D0x%02x driverbyte=3D0x%02x"
>> +			"msgbyte=3D0x%02x statusbyte=3D0x%02x\n",
>> +	       host_byte(result), driver_byte(result), msg_byte(result),
>> +							status_byte(result));
Hi James.
>
> You didn't test this, did you? If you did, you'd have noticed the cha=
nge
> from printk to pr_info gives you an unwanted "6" in the message.
Yes, we tested with "printk" version of the patch, but before sending
the patch, when we checked for issues using "checkpatch.pl" it showed
warning.
So, we thought that to be a cosmetic change and replaced the printk
with  pr_info. Sorry, if below your douting is clear, I will change
log level as current one.

>
> Also, what are you hoping to achieve? scsi_show_result() is only used=
 by
> sd in a very few special command situations.  I can't believe the msg
> byte would be anything other than zero and the status byte check
> condition.
Regarding the introduction of additional information in prints.
We encountered an error with error logs like:
[ 131.673096] sd 0:0:0:0: [sda] Result: hostbyte=3D0x00 driverbyte=3D0x=
08
[ 131.679038] sd 0:0:0:0: [sda] Sense Key : 0xb [current]
[ 131.684801] sd 0:0:0:0: [sda] ASC=3D0x8 ASCQ=3D0x3
[ 131.689241] sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x2a: 2a 00 00 cb 0c 00 0=
0 00 f0 00

Looking at the logs it was clear it was due "ABORTED command" but we
wanted to check in the code if there was any retry in such case:
In =E2=80=98scsi_decide_disposition=E2=80=99 there are "3" main conditi=
ons

switch (host_byte(scmd->result)) -> this returned "DID_OK"
        if (msg_byte(scmd->result) !=3D COMMAND_COMPLETE)
                return FAILED;

And the last was:
switch (status_byte(scmd->result)) {
=E2=80=A6
    case TASK_ABORTED:
                goto maybe_retry;
    case CHECK_CONDITION:
=E2=80=A6

So, if the status/host bytes were known - we could have directly
deduced from the code. Instead we needed to introduce prints and then
check the path.

Thanks.
>
> James
>
>
>
