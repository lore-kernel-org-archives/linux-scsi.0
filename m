From: ael <law_ence.dev@ntlworld.com>
Subject: Re: st.c block limits
Date: Thu, 01 Aug 2002 12:57:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D49220E.3030003@ntlworld.com>
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
> 
> 	Kai

Following up my previous reply where I noted that I had only written 8.8Gb 
to a tape with uncompressed capacity of 10Gb, it then seems that the tape 
firmware is reporting a maximum drive capacity of ~ 16GB.

And perhaps a real tape limit of 17832312 /2 = 8.9GB which is supposedly on 
a 10GB tape : Imation NS-20, specified as 10GB uncompressed. Should I ask 
Imation for replacements :-) ?



ael




