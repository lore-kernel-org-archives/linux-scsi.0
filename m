From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 14:05:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0210241350230.20950-100000@dragon.pdx.osdl.net>
References: <3DB85BFC.2080009@mvista.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DB85BFC.2080009@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 24 Oct 2002, Steven Dake wrote:

| James
| Some responses below:
|
| James Bottomley wrote:
|
| >sdake@mvista.com said:

| >I don't really think it's the job of the kernel to conatin usage information.
| >That's the job of the user level documentation.
| >
| >
| I've gotten mixed feedback on this.  I'll add you to the list that
| doesn't like this.

add me to that list also.

| perhaps it should be removed (even though it takes up minimal memory).
yes, i agree.

| >>Imagine scanning each disk in driverfs looking at its WWN attribute
| >>(if  it has one) until a match is found.  Assume there are 16 FC
| >>devices.  That is  several hundred syscalls just to complete one
| >>hotswap operation.
| >>
| >>
| >
| >Why is speed so important?
| >
| >
| Telecoms and Datacoms have told me in numerous conversations that a hotswap
| operation should occur in 20msec.  I've arbitrarily set 10msec as my
| target to
| ensure that I meet the worse-case bus-is-loaded responses during scans, etc.
|
| I can't mention the names of the telecoms, but several with 10000+ employees
| have mentioned it.

| >>I think this would be too slow.  10 msec for my entire hotswap is
| >>available.  If you calculate 2msec for the actual hotswap disk
| >>operation, that leaves 8 msec for the rest of the mess.  Scanning
| >>through tables or scanning tens or hundreds of files through hundreds
| >>of  syscalls may betoo slow.
| >>
| >
| >Where does the 10ms figure come from?
| >
| See above

I've already ask Steve about this and received his answers.
Can't say that I agree with them though, so I asked someone from
a Telecom Equipment Mfr. about this.  He said that it's just for
equipment testing, where technicians verify that hotswap works,
and they are impatient to wait, so they practice surprise removal
instead of coordinated removal.  He doesn't think that's how it's
actually done out in the field, just in test labs.

Preface question:  does cPCI support surprise removal (in the
PICMG specs, not in some implementation)?  I know that PCI hotplug
doesn't support surprise removal, only "coordinated" removal.

So the question that has to be answered IMO is:  do we want to
support surprise removal for something like manufacturing test,
which doesn't abide by the coordinated removal protocol?

or:  Do we have to support surprise removal, only because it can't
be prevented?  I expect that this is the case, but I still don't
see or understand the 20 ms time requirement.

-- 
~Randy

