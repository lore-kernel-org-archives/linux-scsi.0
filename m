From: ael <law_ence.dev@ntlworld.com>
Subject: Re: st.c block limits
Date: Thu, 01 Aug 2002 12:46:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D491F96.5040604@ntlworld.com>
References: <Pine.LNX.4.44.0207310731150.25578-100000@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Tue, 30 Jul 2002, ael wrote:
> 
> 
>>I have a scsi tape drive:-
>>
>>Host: scsi0 Channel: 00 Id: 00 Lun: 00
>>     Vendor: AIWA     Model: TD-20001         Rev: 0159
>>     Type:   Sequential-Access                ANSI SCSI revision: 02
>>
>>It has worked perfectly for several years, but from kernel 2.4.10 st.c
>>started to report a 24-bit block limit: st0: Block limits 1 - 16777215
>>bytes. I am now on stock 2.4.18 with static char *verstr = "20020205".
>>
>>The above drive is a NS-20 drive with default block size of 512 and 20G
>>blocks: so a range of 25 bits for the block number is needed.
>>
> 
> The block limits tell the block size limits the drive reports, not limits
> to the amount of data. The driver writes data until the drive tells that
> there is no space. I.e., the driver does not limit the amount of data
> written to the tape. No changes affecting this behaviour has been made for
> a very long time.
> 
> 
>>So when I attempt to write to the tape beyond block 2^24,
>>I get an error like:
>>
>># tar -cf /dev/ntape blah_home.tar.bz2; mt  tell
>>tar: /dev/ntape: Wrote only 0 of 10240 bytes
>>tar: Error is not recoverable: exiting now
>>At block 17832312.
>>
> 
> Looks like you are at end of tape. I think the 20 GB capacity is
> compressed and not real. This means that the actual amount of data you can
> write on the tape depends on the compressibility of data. 17.8 GB is
> actually not too bad in this case.

Thanks for the reply.

The tape has a real 10GB capacity. (I believe.)  The 20BG blocks is correct 
for the default block size of 512. So compression is not an issue here. And 
the report above is actually 17.8/2 = 8.9 GB :-(

I did wonder whether some bug in decoding what the drive reports had crept 
in. I will see if I have kept any logs old enough to see what used to 
happen...  Or maybe I have some substandard tapes. It looks as if I had 
better do some more checks.

Thanks anyway,

ael







