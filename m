From: Andrey Melnikov <temnota.am@gmail.com>
Subject: Re: aacraid: kernel: AAC: Host adapter dead -1 (bisected)
Date: Fri, 10 Feb 2017 13:45:06 +0300
Message-ID: <CA+PODjqqvA91Eo1OPr35t9AXmK=SzteCiKjXsb+9xGcB2DyhGA@mail.gmail.com>
References: <589cfa66.rU2EDFCW1W2Xv421%temnota.am@gmail.com> <20170210102447.GA15183@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170210102447.GA15183@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org, arekm@maven.pl, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

Cc: linux-scsi@vger.kernel.org

2017-02-10 13:24 GMT+03:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Fri, Feb 10, 2017 at 02:25:26AM +0300, Andrey Jr. Melnikov wrote:
>> In article <201701151205.37563.a.miskiewicz@gmail.com> you wrote:
>> > Newsgroups: gmane.linux.kernel
>>
>>
>> > Hi.
>>
>> > There is a bug with handling of adaptec raid cards (in my case it is Adaptec
>> > 3405) where kernel logs hundreds of "AAC: Host adapter dead -1" messages.
>>
>> > Bug was reported previously on lkml but there was no progres in solving it.
>>
>> > There is also bugzilla entry:
>> > https://bugzilla.kernel.org/show_bug.cgi?id=151661
>>
>> > I've bisected that to commit bellow and indeed, reverting it from kernel 4.9.3
>> > makes messages go away.
>>
>>
>> Don't try to switch Adaptec 3405/3805 RAID cards to MSI-X interrupt mode.
>> Fix https://bugzilla.kernel.org/show_bug.cgi?id=151661
>>
>> Signed-off-by: Andrey Jr. Melnikov <temnota.am@gmail.com>
>>
>> ---
>>
>> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
>> index 969c312de1be..2ad8403dea40 100644
>> --- a/drivers/scsi/aacraid/aacraid.h
>> +++ b/drivers/scsi/aacraid/aacraid.h
>
> <snip>
>
> Why are you sending this to me and not the scsi developers who can
> actually do something with this patch?

Bug in bugzilla open half year ago, microsemi maintainer slowly read
his fine docs about his hardware, broken driver fills our log with
useless messages every 10 seconds.
So, make decision - apply this patch to stable 4.9.x/4.4.x tree or
revert commit 78cbccd3bd683c295a44af8050797dc4a41376ff from it.
