From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 09 Apr 2010 12:39:11 -0400
Message-ID: <4BBF582F.4040707@interlog.com>
References: <Pine.LNX.4.44L0.1004091118260.1852-100000@iolanthe.rowland.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1004091118260.1852-100000@iolanthe.rowland.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Wed, 7 Apr 2010, Jonas Schwertfeger wrote:
> 
>> On 04/07/2010 05:03 PM, Alan Stern wrote:
>>> In that case, can you repeat the test using an EHCI controller instead
>>> of xHCI?
> 
>> ffff8800345dbb40 2336460054 S Bo:1:004:2 -115 31 = 55534243 96000000 
>> 00020000 80001085 082e0000 00010000 00000000 40a100
>> ffff8800345dbb40 2336460204 C Bo:1:004:2 0 31 >
>> ffff880035f30f00 2336460222 S Bi:1:004:1 -115 512 <
>> ffff880035f30f00 2336460472 C Bi:1:004:1 -32 0
>> ffff8800345dbb40 2336460492 S Co:1:004:0 s 02 01 0000 0081 0000 0
>> ffff8800345dbb40 2336460579 C Co:1:004:0 0 0
>> ffff8800345dbb40 2336460596 S Bi:1:004:1 -115 13 <
>> ffff8800345dbb40 2336460711 C Bi:1:004:1 0 13 = 55534253 96000000 
>> 00020000 01
>> ffff8800345dbb40 2336460729 S Bo:1:004:2 -115 31 = 55534243 97000000 
>> 60000000 80000603 00000060 00000000 00000000 000000
>> ffff8800345dbb40 2336460823 C Bo:1:004:2 0 31 >
>> ffff880035f30f00 2336460841 S Bi:1:004:1 -115 96 <
>> ffff880035f30f00 2336460952 C Bi:1:004:1 0 96 = 720b0000 0000000e 
>> 090c0004 00010000 00000000 40510000 00000000 00000000
> 
> Here's the sense information for the failed ATA-16 passthrough command.  
> I can't interpret it; maybe someone else can.

Descriptor sense format, sense_key=ABORTED_COMMAND
with no additional sense code (0x0,0x0).

It has also added an ATA Return descriptor which
purports to be the ATA registers after the command
is processed. That starts at the 0x09 byte. See
sat2r09.pdf table 114 to decode that.
Since it is an aborted command I would not take
that too seriously.

It is incorrect to have an ATA Return descriptor
with asc,ascq=0x0,0x0 .

Doug Gilbert


