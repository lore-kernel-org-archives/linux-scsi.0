From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Enhanced error handling
Date: Wed, 24 Jul 2002 10:00:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF6F467280.3C70F0C8-ONC1256C00.002BB2CE@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org


Hi,

yes (that's why it is has _irq in its name :-).
Of course, this function can't restore the interrupts
as disabled by the SCSI stack (you don't have flags at hand),
but it enables (some? all?) interrupts.
I don't think it's nice, but I have no better idea.

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Mukul Kotwani <mkotwani@yahoo.com> on 07/23/2002 07:37:17 PM

To:    Martin Peschke3/Germany/IBM@IBMDE
cc:    linux-scsi@vger.kernel.org
Subject:    Re: Enhanced error handling




But does spin_unlock_irq enable interrupts?

Mukul

--- Martin Peschke3 <MPESCHKE@de.ibm.com> wrote:
>
> Hi,
>
> we solved this for the zfcp driver this way:
>
> my_eh_abort_handler() {
>
>       /* unlock and enable interrupts */
>       spin_unlock_irq(&io_request_lock);
>
>       do abort and sleep if necessary
>
>       /* lock and disable interrupts */
>       spin_lock_irq(&io_request_lock);
> }
>
> All those HBA routines should be called without this
> lock held.
> I assume that is or will be changed in 2.5.
>
> Mit freundlichen Gr=FC=DFen / with kind regards
>
> Martin Peschke
>
> IBM Deutschland Entwicklung GmbH
> Linux for eServer Development
> Phone: +49-(0)7031-16-2349
>
>
> Mukul Kotwani <mkotwani@yahoo.com>@vger.kernel.org
> on 07/23/2002 05:16:32
> AM
>
> Sent by:    linux-scsi-owner@vger.kernel.org
>
>
> To:    linux-scsi@vger.kernel.org
> cc:
> Subject:    Enhanced error handling
>
>
>
> Hello!
> After reading a bunch about the new error handling
> code, I have a few
> questions.
>
> I am a low level HBA driver, and the abort handler
> is
> called while the
> io request lock is held. An abort might be completed
> immediately (
> might need to send out an ABORT frame  and wait for
> its completion)
> and therefore might be completed asynchronously. So
> I
> might need to
> sleep in the abort thread, because from what I read,
> it indicated that once the abort call returns, we
> cannot call scsi_done. So the best thing would be to
> wait for the abort to complete.
>
> So my question is:
> If interrupts are disabled when the error handler
> thread is called,
> and I have to sleep, how do I re-enable interrupts ,
> because the abort
> completion is via an interrupt! Ditto with bus
> reset,
> device reset
> etc. How do I get a completion at all? Timer
> interrupts are also
> disabled on a UP system so how does someone get a
> completion at all??
> If I have to re-enable interrupts in the error
> handler
> by calling
> irqrestore, I need the flags , and the low level
> driver does not have
> access to the flags at all. Looking at some sample
> SCSI drivers,they
> seem to be queuing up the abort and returning
> SUCCESS.
> But there is a
> problem there..the mid layer thinks the IO is done
> and
> freed. Say we
> reported as 20 the maximum commands we support,
> wouldnt the mid layer
> send 20 commands down( obviously if it had 20..) ,
> when actually the
> low level driver should be getting 19 because the
> abort of the IO
> might not have completed? Either my understanding is
> totally wrong, or
> this model seems to be somewhat broken. Can someone
> please shed some
> light on this issue?
>
> Thanks!
> Mukul
>
>
> __________________________________________________
> Do You Yahoo!?
> Yahoo! Health - Feel better, live better
> http://health.yahoo.com
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at
> http://vger.kernel.org/majordomo-info.html
>
>
>
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at
http://vger.kernel.org/majordomo-info.html


__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
