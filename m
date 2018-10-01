From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RESEND] scsi: sg: Prevent potential double frees in sg
 driver
Date: Mon, 01 Oct 2018 10:20:37 -0700
Message-ID: <1538414437.171728.7.camel@acm.org>
References: <20181001161506.100284-1-evgreen@chromium.org>
         <CAKwvOdmtF-s4amu-zXbyUNe+jvCuC3hXUez6fVVq0sjuoYc3eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdmtF-s4amu-zXbyUNe+jvCuC3hXUez6fVVq0sjuoYc3eg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, hch@infradead.org
Cc: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Robb Glasser <rglasser@google.com>, evgreen@chromium.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-01 at 10:12 -0700, Nick Desaulniers wrote:
+AD4 On Mon, Oct 1, 2018 at 9:16 AM Evan Green +ADw-evgreen+AEA-chromium.org+AD4 wrote:
+AD4 +AD4 
+AD4 +AD4 From: Robb Glasser +ADw-rglasser+AEA-google.com+AD4
+AD4 +AD4 
+AD4 +AD4 sg+AF8-ioctl could be spammed by requests, leading to a double free in
+AD4 +AD4 +AF8AXw-free+AF8-pages. This protects the entry points of sg+AF8-ioctl where the
+AD4 +AD4 memory could be corrupted by a double call to +AF8AXw-free+AF8-pages if multiple
+AD4 +AD4 requests are happening concurrently.
+AD4 +AD4 
+AD4 +AD4 Signed-off-by: Robb Glasser +ADw-rglasser+AEA-google.com+AD4
+AD4 +AD4 Signed-off-by: Nick Desaulniers +ADw-ndesaulniers+AEA-google.com+AD4
+AD4 +AD4 Signed-off-by: Evan Green +ADw-evgreen+AEA-chromium.org+AD4
+AD4 +AD4 Cc: stable+AEA-vger.kernel.org
+AD4 +AD4 
+AD4 +AD4 ---
+AD4 +AD4 Reposting this patch from last summer, as it looks like it fell in between
+AD4 +AD4 the cracks.
+AD4 
+AD4 Christoph, do you still feel strongly about: https://lkml.org/lkml/2017/8/5/75 ?

I don't know how Christoph feels about it, but serializing all SG I/O seems
like a regression to me. If one sg command hangs I usually try to send
another sg command to the same SCSI device from another shell to get more
information about the nature of the hang. Serializing all SG I/O would make
that impossible.

Bart.
