From: Dror Levin <drorl@infinidat.com>
Subject: Re: Recent removal of bsg read/write support
Date: Thu, 4 Oct 2018 09:58:37 +0300
Message-ID: <CAOuWhkYRtTqrnp1uyDWFqXFcTLhPbcqv8XzdV_jurJHstGQmuA@mail.gmail.com>
References: <CAOuWhkaGjX8Q_xghkFVTqzZkDrUv-sdH=VbS7hvnqFWrT+3eOQ@mail.gmail.com>
 <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
 <CA+55aFyLC8PhjZ+iV7MucSZ1aGKMT=S9=EkEAQ6T1=ZRqD-xLA@mail.gmail.com> <CAOuWhkbNuesaVYar6ML-qFw7RAfkPsaOYUXT4Ypfiu5=Nt1kWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOuWhkbNuesaVYar6ML-qFw7RAfkPsaOYUXT4Ypfiu5=Nt1kWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: Richard Weinberger <richard.weinberger@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org

CC'ing Greg.

On Mon, Sep 3, 2018 at 11:34 AM Dror Levin <drorl@infinidat.com> wrote:
>
> On Sun, Sep 2, 2018 at 8:55 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sun, Sep 2, 2018 at 4:44 AM Richard Weinberger
> > <richard.weinberger@gmail.com> wrote:
> > >
> > > CC'ing relevant people. Otherwise your mail might get lost.
> >
> > Indeed.
>
> Sorry for that.
>
> > > On Sun, Sep 2, 2018 at 1:37 PM Dror Levin <drorl@infinidat.com> wrote:
> > > >
> > > > We have an internal tool that uses the bsg read/write interface to
> > > > issue SCSI commands as part of a test suite for a storage device.
> > > >
> > > > After recently reading on LWN that this interface is to be removed we
> > > > tried porting our code to use sg instead. However, that raises new
> > > > issues - mainly getting ENOMEM over iSCSI for unknown reasons.
> >
> > Is there any chance that you can make more data available?
>
> Sure, I can try.
>
> We use writev() to send up to SG_MAX_QUEUE tasks at a time. Occasionally not
> all tasks are written at which point we wait for tasks to return before
> sending more, but then writev() fails with ENOMEM and we see this in the syslog:
>
> Sep  1 20:58:14 gdc-qa-io-017 kernel: sd 441:0:0:5: [sg73]
> sg_common_write: start_req err=-12
>
> Failing tasks are reads of 128KiB.
>
> > I'd rather fix the sg interface (which while also broken garbage, we
> > can't get rid of) than re-surrect the bsg interface.

Discussion seems to have died down but release of 4.19 is drawing near.

Is there still any chance removal of bsg can be reconsidered? Maybe
postponed to the
next version to allow more time to adjust?

I'm especially concerned about the possibility of this being
backported to stable kernels
which might leave us very little time to fix our code.

Thanks,
Dror
