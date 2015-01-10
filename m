From: Christoph Hellwig <hch@lst.de>
Subject: Re: old linux scsi headers
Date: Sat, 10 Jan 2015 11:10:12 +0100
Message-ID: <20150110101012.GA27454@lst.de>
References: <54B0122A.9050509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-56187-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <54B0122A.9050509@redhat.com>
To: Andy Grover <agrover@redhat.com>
Cc: libc-alpha@sourceware.org, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 09, 2015 at 09:38:50AM -0800, Andy Grover wrote:
> Hello glibc people,
>
> This concerns sysdeps/unix/sysv/linux/scsi/{scsi, scsi_ioctl, sg}.h
>
> They define common SCSI values, as well as Linux's SCSI-related ioctls.
>
> Apparently they were copied from the Linux kernel tree back in 1999, so 
> they're pretty stale.
>
> I'm wondering if I should submit a patch to update these to what's current 
> from the Linux tree, or if maybe it wouldn't be better to have users just 
> directly get these as "uapi" headers from the Linux kernel source directly?
>
> The latter method has issues with being a breaking change for code that 
> relies on what's in glibc now, which may or may not be something we can 
> ease, but would ensure the headers would not become stale again in the 
> future.
>
> What do you think about the best way to proceed?

FYI, I'd like to repeat my propsal from the scsi list here, and a
few alternatives:

(1) separate namespaces (my proposal):

 - we add uapi linux/scsi_ioctl.h and linux/sg.h files that just
   add the ioctl defintions and data structures required for them.
 - because they are linux/ instead of scsi/ are not required to keep
   things like the old opcode or SCSI-2 defintions, which glibc
   can keep in the scsi/* wrappers, and hopefully slowly deprecate
   over the long run

(2) just export what we have in the kernel now (Andys patch):

 - add uapi scsi/scsi.h and scsi/scsi_ioctl.h (and scsi/sg.h for v2),
   exporting what we have in them right now, which might be a little
   different from glibc
 - remove glibcs scsi/*.h

(2a)

 - like 2, but only export the ioctls APIs, the other constants
   will go away at this point

(2b)

 - like 2a, but also add defines compatible to glibc under
   #ifndef __KERNEL__ to the uapi headers.
