From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH v5] scsi/ata: Use unsigned int for cmd's type in ioctls
 in scsi_host_template
Date: Fri, 8 Feb 2019 09:00:44 -0700
Message-ID: <20190208160044.GB26005@archlinux-ryzen>
References: <20190126075256.29608-1-natechancellor@gmail.com>
 <20190207160719.28895-1-natechancellor@gmail.com>
 <20190208080501.GA18530@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190208080501.GA18530@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Brian King <brking@us.ibm.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Marc Gonzalez <marc.w.gonzalez@free.fr>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Bradley Grove <bgrove@attotech.com>, Don Brace <don.brace@microsemi.com>, Bart Van Assche <bvanassche@acm.org>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 08, 2019 at 12:05:01AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 07, 2019 at 09:07:20AM -0700, Nathan Chancellor wrote:
> > Clang warns several times in the scsi subsystem (trimmed for brevity):
> > 
> > drivers/scsi/hpsa.c:6209:7: warning: overflow converting case value to
> > switch condition type (2147762695 to 18446744071562347015) [-Wswitch]
> >         case CCISS_GETBUSTYPES:
> >              ^
> > drivers/scsi/hpsa.c:6208:7: warning: overflow converting case value to
> > switch condition type (2147762694 to 18446744071562347014) [-Wswitch]
> >         case CCISS_GETHEARTBEAT:
> >              ^
> > 
> > The root cause is that the _IOC macro can generate really large numbers,
> > which don't fit into type 'int', which is used for the cmd parameter in
> > the ioctls in scsi_host_template. My research into how GCC and Clang are
> > handling this at a low level didn't prove fruitful. However, looking at
> > the rest of the kernel tree, all ioctls use an 'unsigned int' for the
> > cmd parameter, which will fit all of the _IOC values in the scsi/ata
> > subsystems.
> > 
> > Make that change because none of the ioctls expect a negative value for
> > any command, it brings the ioctls inline with the reset of the kernel,
> > and it removes ambiguity, which is never good when dealing with compilers.
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/85
> > Link: https://github.com/ClangBuiltLinux/linux/issues/154
> > Link: https://github.com/ClangBuiltLinux/linux/issues/157
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > Acked-by: Bradley Grove <bgrove@attotech.com>
> > Acked-by: Don Brace <don.brace@microsemi.com>
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you for the review, it is much appreciated!

Nathan
