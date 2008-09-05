From: "Mark Nelson" <mdnelson8@gmail.com>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Fri, 5 Sep 2008 12:28:49 +1000
Message-ID: <65a6ef750809041928u3a14b529vdb71c68b0cf8e3fa@mail.gmail.com>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	 <48BD2136.1020101@garzik.org>
	 <65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>
	 <18621.11426.870514.781750@harpo.it.uu.se>
	 <65a6ef750809020521wfaca733r8253795860b95f4@mail.gmail.com>
	 <48BFBA5E.5050300@garzik.org>
	 <65a6ef750809040459h3ffe3183nf0b5a35d15ab86e4@mail.gmail.com>
	 <48BFE5FA.9090006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48BFE5FA.9090006@garzik.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 4, 2008 at 11:43 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Mark Nelson wrote:
>>
>> On Thu, Sep 4, 2008 at 8:37 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>
>>> Mark Nelson wrote:
>>>>
>>>> On Tue, Sep 2, 2008 at 10:08 PM, Mikael Pettersson <mikpe@it.uu.se>
>>>> wrote:
>>>>>
>>>>> Mark Nelson writes:
>>>>>  > On Tue, Sep 2, 2008 at 9:19 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>>>  > > Mark Nelson wrote:
>>>>>  > >>
>>>>>  > >> Add an appropriate entry for the Promise PDC42819 controller. It
>>>>> has an
>>>>>  > >> AHCI mode and seems to work correctly with board_ahci.
>>>>>  > >>
>>>>>  > >> This chip is found on Promise's FastTrak TX2650 (2 port) and
>>>>> TX4650
>>>>> (4
>>>>>  > >> port)
>>>>>  > >> software-based RAID cards (for which there is a binary driver,
>>>>> t3sas) and
>>>>>  > >> can be found on some motherboards, for example the MSI K9A2
>>>>> Platinum,
>>>>>  > >> which calls the chip a Promise T3 controller.
>>>>>  > >>
>>>>>  > >> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
>>>>>  > >> ---
>>>>>  > >> Apparently this chip also supports SAS disks, will these work
>>>>> with
>>>>> the
>>>>>  > >> ahci driver (I've only tested with normal desktop SATA disks)?
>>>>>  > >
>>>>>  > > ahci is definitely SATA-only, so I wonder how they modified AHCI
>>>>> to
>>>>> support
>>>>>  > > SAS transport...
>>>>>  >
>>>>>  > That is a good question. From my understanding the controller is a
>>>>> SAS
>>>>>  > controller that can drive SATA disks (as I guess all SAS controllers
>>>>> can
>>>>>  > do...). Could it be that the controller can be setup to act as an
>>>>> AHCI
>>>>>  > SATA controller or if the right registers are poked a SAS
>>>>> controller?
>>>>>
>>>>> Based on how the sata_promise-supported chips work I'd guess that they
>>>>> have dual programming interfaces with AHCI for JBOD SATA and a native
>>>>> one (perhaps just additional control registers) for SAS and raid.
>>>>>
>>>> That's interesting; and makes sense. I'm guessing that we won't end up
>>>> with an open source driver that can do SAS on these chips then... But
>>>> for now at least we can use them as SATA controllers and if Promise
>>>> wants to come to the table with specs or datasheets they can in the
>>>> future. I'm just happy to be able to use my eSATA ports (and perhaps
>>>> the possibility of getting my hard disk off the SB600, although I should
>>>> benchmark both controllers before jumping to any conclusions).
>>>
>>> FWIW, I'll poke my Promise contacts, but they have gone mostly silent in
>>> the
>>> past year, so don't get your hopes up...
>>
>> Thanks Jeff!
>>
>> No need for hope - we have ahci now :)
>
> Well, I still think this PCI ID addition leaves open the possibility that
> plugging in a SAS disk could hang the system or similar misbehavior.
>

Fair point.

I'm not sure if this is any better but I could change the PCI ID to
specify the subvendor as 0x1462 (MSI) so that it will only match with
T3 controllers on MSI boards (like my K9A2 Platinum). I'd guess that
most people who bought the board would use the T3 for SATA disks
rather than SAS while most people who bought the dedicated
Promise controller would have bought it to use with SAS disks (but
admittedly that assumption could be fundamentally flawed - maybe
people bought the MSI board for the sole purpose of using SAS
without having to buy a discrete controller...)

Thanks!

Mark
