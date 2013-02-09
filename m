From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 2/3] target: Fix error checking for UNMAP commands
Date: Sat, 9 Feb 2013 11:27:31 -0800
Message-ID: <CAL1RGDXZL6cBh5Jc1aSkS-MqmA0pZ_HaKKm7HHQZ9RCay+CgQQ@mail.gmail.com>
References: <1360365520-11972-1-git-send-email-roland@kernel.org>
 <1360365520-11972-2-git-send-email-roland@kernel.org> <51161593.9030007@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:54281 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758494Ab3BIT1y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2013 14:27:54 -0500
Received: by mail-ee0-f71.google.com with SMTP id t10so5478578eei.2
        for <linux-scsi@vger.kernel.org>; Sat, 09 Feb 2013 11:27:52 -0800 (PST)
In-Reply-To: <51161593.9030007@bootc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Feb 9, 2013 at 1:23 AM, Chris Boot <bootc@bootc.net> wrote:
>> +       case TCM_PARAMETER_LIST_LENGTH_ERROR:
>> +               /* CURRENT ERROR */
>> +               buffer[0] = 0x70;
>> +               buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
>> +               /* ILLEGAL REQUEST */
>> +               buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
>> +               /* INVALID FIELD IN PARAMETER LIST */
>> +               buffer[SPC_ASC_KEY_OFFSET] = 0x1a;
>> +               break;
>>         case TCM_UNEXPECTED_UNSOLICITED_DATA:
>>                 /* CURRENT ERROR */
>>                 buffer[0] = 0x70;
>
>
> Nitpick: I suspect a simple copy & paste error; "INVALID FIELD IN PARAMETER
> LIST" in your comment should probably read "PARAMETER LIST LENGTH ERROR"
> instead.

Yes, the comment is a copy and paste error.  The ASC of 1Ah is correct for
PARAMETER LIST LENGTH ERROR.  Thanks & good catch.

Nic, want me to resend?

 - R.
