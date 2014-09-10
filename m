From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 1/2] uas: Set no_report_opcodes
Date: Wed, 10 Sep 2014 10:17:04 +0200
Message-ID: <54100900.2050109@redhat.com>
References: <1410274800-11578-1-git-send-email-hdegoede@redhat.com> <1410274800-11578-2-git-send-email-hdegoede@redhat.com> <20140909160150.GA15724@infradead.org> <540F5333.80201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <540F5333.80201@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/09/2014 09:21 PM, Hans de Goede wrote:
> Hi,
> 
> On 09/09/2014 06:01 PM, Christoph Hellwig wrote:
>> On Tue, Sep 09, 2014 at 04:59:59PM +0200, Hans de Goede wrote:
>>> asm1051e usb <-> sata bridges hang when receiving a report opcodes scsi cmnd.
>>> Take a page out of the usb-storage book, and simple disable no_report_opcodes
>>> outright.
>>
>> Given that this device also seems broken in other ways can we wait a bit
>> before using the big hammer?
> 
> Actually the big hammer I would like to avoid is disabling uas all together
> on these devices, as they work fine with 2 out of 3 of the 3 disks I've
> tested with, as long as no report opcodes is not used.
> 
> Which is why my other patch also includes a log message to explain how
> to enable uas despite the blacklist, but that will only work if we don't
> send report opcodes.
> 
>> I'm still hoping UAS might give us some
>> better SCSI implementation so that we don't have to disable any kind of
>> advanced feature.
> 
> I understand, so an alternative would be to make this a quirk and only
> set it for ASM1051/ASM1053 bridges.

So further (stress) testing of ASM1051 bridges with disks with which they
do work under normal conditions have shown that even with those disks
they can get stuck / hang in a state which can only be recovered by an
unplug + replug (power cycle).

So basically ASM1051 bridges should just never be used together with uas,
which means that this patch can be dropped.

So: self-nak.

I'll respin the second patch in this set to change the log messages a
bit to reflect this new insight.

Regards,

Hans
