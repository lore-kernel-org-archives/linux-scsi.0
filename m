From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH RESEND] scsi: sg: Prevent potential double frees in sg driver
Date: Tue, 2 Oct 2018 08:21:26 -0700
Message-ID: <CAE=gft5TFz4XQMLp8zH83W-agq-B7Df_1X-kX-UrSg8g1vipmw@mail.gmail.com>
References: <20181001161506.100284-1-evgreen@chromium.org> <ef53fcb4-9001-c06b-779f-d40949224c98@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ef53fcb4-9001-c06b-779f-d40949224c98@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ndesaulniers@google.com, hch@infradead.org, rglasser@google.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 1, 2018 at 4:34 PM Douglas Gilbert <dgilbert@interlog.com> wrote:
>
> On 2018-10-02 02:15 AM, Evan Green wrote:
> > From: Robb Glasser <rglasser@google.com>
> >
> > sg_ioctl could be spammed by requests, leading to a double free in
> > __free_pages. This protects the entry points of sg_ioctl where the
> > memory could be corrupted by a double call to __free_pages if multiple
> > requests are happening concurrently.
>
> Hi,
> I  don't like this patch. I would like to see the trace for the double
> call to the __free_pages you are referring too. A test program that
> show the fault, perhaps?
>
> I have test code to "spam" the sg driver and have not seen a double
> __free_pages that you refer to (see sg3_utils package version 1.44,
> testing/sg_tst_async.cpp).
>
> Currently I am dusting off 20 years of "laparoscopic" patches to the sg
> driver that have made a bit of a mess of the naming and comments. Also
> the 16 outstanding requests per file descriptor limit is being removed.
> Then I want to add the SG_IOSUBMIT and SG_IORECEIVE ioctls proposed by
> Linus Torvalds two week ago.
>
> Executive summary: nak, without further information

That makes sense. Thanks for taking a look.
