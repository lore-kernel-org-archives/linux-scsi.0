From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Sym53C8xx Driver Hardening
Date: 23 Jul 2002 16:24:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1027437862.31787.136.camel@irongate.swansea.linux.org.uk>
References: <200207231357.PAA02632@cave.bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200207231357.PAA02632@cave.bitwizard.nl>
List-Id: linux-scsi@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>, linux-scsi@vger.kernel.org

On Tue, 2002-07-23 at 14:57, Rogier Wolff wrote:
> Now it won't be as easy as this. But for instance in my firestream
> driver, you sometimes put a value in a register in the chip, and if
> later on you read it back, you want the chip to have left it
> unmodified, or to have it changed in a predictable way. If the value
> is unexpected, a panic is the right "way out". 

The high reliability people take a different view. I actually agree with
them. It isnt about 'oops didnt happen' it is about controlling the
failure case

Suppose your firestream driver reports catacylsmic internal error
status. Their argument is not that you should pretend life is good but
that the driver should log a fault and shut off the chip as best it can.
So you might have a firestream_failed() function which did

	Disable master bit
	Put board into D3
	Wait
	Put board into running state
	Try to reset and configure it
	If this fails shove it in D3 and give up

At this point the high reliability system is servicing the other links
it manages and flashing warning lights to the engineers, rather than
completely down

