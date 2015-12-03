From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Thu, 3 Dec 2015 16:11:49 -0500
Message-ID: <5660B015.5050804@interlog.com>
References: <20151201202053.GA4753@glen>
 <1449097101.2203.67.camel@HansenPartnership.com> <20151203203656.GA9278@glen>
 <1449176346.2187.19.camel@HansenPartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449176346.2187.19.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15-12-03 03:59 PM, James Bottomley wrote:
> On Thu, 2015-12-03 at 21:36 +0100, Andrea Gelmini wrote:
>> On Wed, Dec 02, 2015 at 02:58:21PM -0800, James Bottomley wrote:
>>> On Tue, 2015-12-01 at 21:20 +0100, Andrea Gelmini wrote:
>>> OK, this looks like some type of problem with a USB enclosure.  It's
>>> probably misreporting something in the mode pages.  can you run sg_ses
>>> on whatever /dev/sg<n> the enclosure turns up as?
>>
>>
>> root@glen:/tmp/report# cat sg_ses_usb_hd.txt
>>    WD        My Passport 0820  1007
>>      disk device (not an enclosure)
>> Supported diagnostic pages:
>>    Supported Diagnostic Pages [sdp] [0x0]
>>    Short Enclosure Status (SES) [ses] [0x8]
>>    <unknown> [0x80]
>>    <unknown> [0x83]
>>    <unknown> [0x84]
>>    <unknown> [0x85]
>
> Actually, I'm afraid that's the wrong device; it's the disk not the
> enclosure (that's why sg_ses says not an enclosure)
>
> If you do
>
> sg_map -i
>
> in your system, you should see something with an inquiry string like
> enclosure.  It's the /dev/sg<n> of that you need to run sg_ses on.

Or use lsscsi like this and look for lines with 'enclosu' in
its output:
   # lsscsi -gs
[3:0:0:0]  disk    ATA     ST3160812AS      D     /dev/sda  /dev/sg0  160GB
[6:0:0:0]  disk    SEAGATE ST200FM0073      0007  /dev/sdb  /dev/sg1  200GB
[6:0:1:0]  enclosu Areca   ARC-802801.13.1D 0113  -         /dev/sg2      -

Then:
   # sg_ses /dev/sg2
   Areca     ARC-802801.13.1D  0113
Supported diagnostic pages:
   Supported Diagnostic Pages [sdp] [0x0]
   Configuration (SES) [cf] [0x1]
   Enclosure Status/Control (SES) [ec,es] [0x2]
   String In/Out (SES) [str] [0x4]
   Threshold In/Out (SES) [th] [0x5]
   Element Descriptor (SES) [ed] [0x7]
   Additional Element Status (SES-2) [aes] [0xa]
   Supported SES Diagnostic Pages (SES-2) [ssp] [0xd]
   Download Microcode (SES-2) [dm] [0xe]
   Subenclosure Nickname (SES-2) [snic] [0xf]
   Protocol Specific (SAS transport) [] [0x3f]

Doug Gilbert


Doug Gilbert
