From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: START-STOP under Linux 2.4
Date: Wed, 2 Apr 2003 13:49:15 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304021339530.17468-200000@ida.rowland.org>
References: <20030402093236.A15801@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-2084555674-431246170-1049309355=:17468"
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030402093236.A15801@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---2084555674-431246170-1049309355=:17468
Content-Type: TEXT/PLAIN; charset=US-ASCII

Greg:

This patch for 2.4.21-pre6 (a backport from 2.5) removes a source of
problems for many usb-storage devices by replacing a START-STOP command,
used to determine if the drive media is loaded, with a TEST-UNIT-READY.  
In the past people have handled this by creating entries in unusual_devs.h
with the US_FL_START_STOP flag; now that should no longer be necessary.

Alan Stern


On Wed, 2 Apr 2003, Matthew Dharm wrote:

> Send it to Greg K-H -- he'll send it to Marcello.
> 
> Matt
> 
> On Wed, Apr 02, 2003 at 10:24:47AM -0500, Alan Stern wrote:
> > Great!  I'll try to get this into the official kernel source.
> > 
> > Matt:  Do you know the appropriate person to send this patch to for
> > inclusion in 2.4.21?
> > 
> > Alan Stern
> > 
> > 
> > On Tue, 1 Apr 2003, John Goerzen wrote:
> > 
> > > Alan Stern <stern@rowland.harvard.edu> writes:
> > >
> > > > Based on the kernel log you posted earlier, it looks like your problem may
> > > > stem from the use of a START-STOP command.  The patch below removes that
> > > > command; it's a backport from 2.5.  Try installing this and let us know if
> > > > it helps.
> > >
> > > Indeed it does!  Things seem to work fine with your patch.
> > 
> > On 1 Apr 2003, Chris Worley wrote:
> > 
> > > Bingo.
> > >
> > > This worked great.  There was a little tweak on the sd.c patch for the
> > > 2.4.19 kernel, but it was apparent.
> > >
> > > Thanks!


---2084555674-431246170-1049309355=:17468
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="sd.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.0304021349150.17468@ida.rowland.org>
Content-Description: START-STOP patch for 2.4.21-pre6
Content-Disposition: attachment; filename="sd.patch"

LS0tIGxpbnV4LTIuNC4yMS9kcml2ZXJzL3Njc2kvc2QuYy5vcmlnCU1vbiBN
YXIgMzEgMTY6Mjc6MzEgMjAwMw0KKysrIGxpbnV4LTIuNC4yMS9kcml2ZXJz
L3Njc2kvc2QuYwlNb24gTWFyIDMxIDE2OjU2OjIwIDIwMDMNCkBAIC03MzEs
MTUgKzczMSwxNyBAQA0KIAkJCQkgKiBjaGVja19kaXNrX2NoYW5nZSAqLw0K
IAl9DQogDQotCS8qIFVzaW5nIFN0YXJ0L1N0b3AgZW5hYmxlcyBkaWZmZXJl
bnRpYXRpb24gYmV0d2VlbiBkcml2ZSB3aXRoDQorCS8qDQorCSAqIFVzaW5n
IFRFU1RfVU5JVF9SRUFEWSBlbmFibGVzIGRpZmZlcmVudGlhdGlvbiBiZXR3
ZWVuIGRyaXZlIHdpdGgNCiAJICogbm8gY2FydHJpZGdlIGxvYWRlZCAtIE5P
VCBSRUFEWSwgZHJpdmUgd2l0aCBjaGFuZ2VkIGNhcnRyaWRnZSAtDQogCSAq
IFVOSVQgQVRURU5USU9OLCBvciB3aXRoIHNhbWUgY2FydHJpZGdlIC0gR09P
RCBTVEFUVVMuDQotCSAqIFRoaXMgYWxzbyBoYW5kbGVzIGRyaXZlcyB0aGF0
IGF1dG8gc3BpbiBkb3duLiBlZyBpb21lZ2EgamF6IDFHQg0KLQkgKiBhcyB0
aGlzIHdpbGwgc3BpbiB1cCB0aGUgZHJpdmUuDQorCSAqDQorCSAqIERyaXZl
cyB0aGF0IGF1dG8gc3BpbiBkb3duLiBlZyBpb21lZ2EgamF6IDFHLCB3aWxs
IGJlIHN0YXJ0ZWQNCisJICogYnkgc2RfaW5pdF9vbmVkaXNrKCksIHdoZW5l
dmVyIHJldmFsaWRhdGVfc2NzaWRpc2soKSBpcyBjYWxsZWQuDQogCSAqLw0K
IAlyZXR2YWwgPSAtRU5PREVWOw0KIAlpZiAoc2NzaV9ibG9ja193aGVuX3By
b2Nlc3NpbmdfZXJyb3JzKFNEZXYpKQ0KLQkJcmV0dmFsID0gc2NzaV9pb2N0
bChTRGV2LCBTQ1NJX0lPQ1RMX1NUQVJUX1VOSVQsIE5VTEwpOw0KKwkJcmV0
dmFsID0gc2NzaV9pb2N0bChTRGV2LCBTQ1NJX0lPQ1RMX1RFU1RfVU5JVF9S
RUFEWSwgTlVMTCk7DQogDQogCWlmIChyZXR2YWwpIHsJCS8qIFVuYWJsZSB0
byB0ZXN0LCB1bml0IHByb2JhYmx5IG5vdCByZWFkeS4NCiAJCQkJICogVGhp
cyB1c3VhbGx5IG1lYW5zIHRoZXJlIGlzIG5vIGRpc2MgaW4gdGhlDQo=
---2084555674-431246170-1049309355=:17468--
