From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: esp_scsi QTAG in FAS216
Date: Sun, 13 Apr 2014 16:47:45 +0200
Message-ID: <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com>
References: <CAOmrzkKP4YcvnHcrtucMvS9WSaeg+6-qnobOWN6hBK=wkUHemg@mail.gmail.com>
	<CAMuHMdUH=9sv-Vb3ZTAGyfvEQOO0x0x1cUYhfd7040k8d+bSYg@mail.gmail.com>
	<5231DF69.6070807@aalto.fi>
	<20140404.162830.1700547572091852195.davem@davemloft.net>
	<CAOmrzkL_6Y2RhpKANmTEWL53-6Ts+PF9Hhk_4Fh1s0wx7f_NhQ@mail.gmail.com>
	<CACz-3rg3LNFKNPUNwc1OF_O_b5k=28hw8Nj50dWhxy4A5_QbVg@mail.gmail.com>
	<CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: David Miller <davem@davemloft.net>, Tuomas Vainikka <tuomas.vainikka@aalto.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Michael,


2014-04-11 3:47 GMT+02:00 Michael Schmitz <schmitzmic@gmail.com>:
> The more important issue is the one about the one-byte reconnect
> message. Does the manual speak to that particular issue? Any hint on
> how we could enable SCSI-2 features on chip init?

There's the SCSI2 bit in the Config 2 register and/or the QTE bit in
the Config 3 register. The 53CF9x-2 manual says about SCSI-2 bit:

Bit 2 SCSI-2

Setting this bit allows the FSC to support two new features adopted in
SCSI-2: the 3-byte message exchange for Tagged-Queueing and Group 2
commands. These features can also be set independently in the Config 3
register.

Tagged-Queueing
When this bit is set and the FSC is selected with ATN (Attention), it
will request either one or three message bytes depending on whether
ATN remains true or goes false. If ATN is still true after the first
byte has been received, the FSC may request two more message bytes
before switching to Command phase. If ATN goes false, it will switch
to Command phase after the first message byte. When the bit is not set
it will request a single message byte (as a target) when selected with
ATN, and abort the selection sequence (as an initiator) if the target
does not switch to Command phase after one message byte has been
transferred.

Group 2 Commands
(seems to only be relevant for target mode).

And about the QTE bit:

Bit 6 Queue Tag Enable

When this bit is set, the 53CF94/96 can receive 3-byte messages during
bus-initiated Select With ATN. This feature is also enabled by setting
bit 3 in the Configuration 2 register.
The message bytes consist of a one-byte identify message and a
two-byte queue tag message. The middle byte is the tagged queue
message itself and the last byte is the tag value (0 to 255). When
this bit is set, the second byte is checked to see if it is a valid
queue tagging message. If the value of the byte is not 20, 21 or 22h,
the sequence halts and an interrupt is generated. When this bit is not
set, the chip aborts the Select With ATN sequence after it receives
one Identify Message byte, if ATN is still asserted.

Then there is a section called "Bus Initiated Reselection":

Bus Initiated Reselection
The FSC will allow itself to be reselected as an initiator by a target
if it has previously received the Enable Selection/Reselection
command. If the sequence completes normally, the following information
will be in the FIFO:

* Bus ID
* Identify Message
* Optional 2-byte queue tag message

The bus ID will always be present and will always be one byte. It is
an un-encoded version of the state of the bus during Reselection
phase.

The identify message will always be present and will always be one byte.

If queue tagging is enabled, and the target is sending a queue tag
message, the target will also send two queue tag message bytes.

> Can you point me to a source for the manuals if possible?

I only have dead tree versions of the QLogic manual and the Symbios
Logic manual.

The only public place I know of is bitsavers, they do have a manual
for the 53C94/95/96 online here:
http://bitsavers.trailing-edge.com/pdf/ncr/scsi/NCR_53C94_53C95_53C96_Data_Sheet_Feb90.pdf.

I put the 53C90A/B manual online at
http://members.home.nl/karsdejong/NCR53C90ab.pdf and a preliminary
version of the 53CF94/96-2 at
http://members.home.nl/karsdejong/NCR53CF9x-2.pdf.


Kind regards,

Kars.
