From: R.E.Wolff@BitWizard.nl (Rogier Wolff)
Subject: Re: Sym53C8xx Driver Hardening
Date: Tue, 23 Jul 2002 15:57:56 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207231357.PAA02632@cave.bitwizard.nl>
References: <5009AD9521A8D41198EE00805F85F18F219A7C@sembo111.teknor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <5009AD9521A8D41198EE00805F85F18F219A7C@sembo111.teknor.com> from
 "Isabelle, Francois" at "Jul 23, 2002 09:29:53 am"
List-Id: linux-scsi@vger.kernel.org
To: "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>
Cc: linux-scsi@vger.kernel.org

Isabelle, Francois wrote:
> Some of the features:
>  - Panic removal
>  - Standardized event logging
>  - Parameter checking ...

Panic removal is NOT a good thing. 

A panic should only happen wehn the driver/kernel/whatever CANNOT
continue because of some serious problem.

A panic should occurin cases like: 

	b = 2 + 3;

	....

	if (b != 5) panic (); 


Now it won't be as easy as this. But for instance in my firestream
driver, you sometimes put a value in a register in the chip, and if
later on you read it back, you want the chip to have left it
unmodified, or to have it changed in a predictable way. If the value
is unexpected, a panic is the right "way out". 

If this is NOT done, the chip may be DMA-ing data into the wrong spot
in main memory. This will not panic your system, but crash it (*). A
panic can be configured to "do the right thing": reboot, and be back
in business as soon as possible. An operator should then be notified
and somehow take action.

Removing panics sounds like a manager-solution to the problem: A
system that panics is not reliable, so we should remove the panics.

Well, if the code panics for the right reason, then the panic is
to be preferred above continuing. 

I'm convinced that most linux-code is well-written in this respect.

			Rogier. 

(*) A crash is meant as where the system ends up being wedged, with
only a hardware watchdog able to get it out of that state.


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2137555 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* There are old pilots, and there are bold pilots. 
* There are also old, bald pilots. 
