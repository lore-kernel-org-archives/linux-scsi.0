From: Dario Oliva <anikami1@gmail.com>
Subject: Re: IO Data USB HD - read/write with SGIO ioctl does not acces the
 drive, kernel 2.6.15.6 - FIXED
Date: Tue, 16 May 2006 13:28:27 -0400
Message-ID: <446A0BBB.7050605@gmail.com>
References: <4468E16F.4060709@gmail.com> <4469FD42.7060906@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:19170 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1751733AbWEPR2g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 13:28:36 -0400
Received: by wr-out-0506.google.com with SMTP id i5so34258wra
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2006 10:28:36 -0700 (PDT)
In-Reply-To: <4469FD42.7060906@yk.rim.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Chiaki wrote:
>
> It is very possible that the USB<-> ATA(SCSI?) bridge
> may not be clever/powerful enough to
> understand the emulated SCSI protocol correctly.
>
> I have a I-O HDH-U USB external disk drive
> with USB<->ATA bridge inside. (Don't know whether
> the manufacrer is the same as yours, but it looks to
> be the same manufacturer.)
>
> Obviously S.M.A.R.T. information could not be
> passed across this bridge until last April this year.
> I-O Device, the manufacturer, issued an upgrade
> of the bridge firmware last month, and now at least a particular
> S.M.A.R.T.-aware program under Windows XP
> can read the S.M.A.R.T. information
> from the ATA disk in the external enclosure. Go figure.
>
>
> Dario Oliva wrote:
>> I am trying to use the SG_IO ioctl from the scsi driver to read and 
>> write raw
>> data to this USB hard drive (IO Data USB HD). I have googled the 
>> device name and
>> only came up with 13 sites, none of which had any information for 
>> this problem.
>> This is a link to a reseller in California who sells the device I am 
>> using
>> http://www.devicenet-usa.com/product_en.html#hdp
>>
>> To verify that the data was not being written from the device or read 
>> from the device,
>> I used a protocol analyzer connected to the hard disk While sending 
>> the read or write
>> commands using SG_IO, there was no activity on the disk. I have also 
>> used a program I wrote
>> that reads individual sectors from a disk and displays the data in a 
>> format similar to hexdump.
>> The output from that program is also attached, in the file named 
>> data. As you will see, I did a read
>> several times from sector 0, receiving different slightly different 
>> values every time.
>>
>> I am attaching output from dmesg gathered while connecting and 
>> reading from the device.
>>
>>
>> Where should I go from here? Are there other debug messages I can 
>> enable within the scsi generic drivers.
>>
>>
>> Dario Oliva
>
>
Thanks for all the input. I was able to use sg_dd to figure out how
that program was sending the SCSI read10 command compared to
how I was sending it. I was setting the control byte (byte 9 in the 10-byte
command structure) to 1, and should have been setting it to 0.

After setting it to 0, everything worked fine.

Dario Oliva
