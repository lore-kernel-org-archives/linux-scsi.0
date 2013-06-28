From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI vs MN10300: Can get_user() be given an array?
Date: Fri, 28 Jun 2013 11:16:59 -0700
Message-ID: <1372443419.1884.12.camel@dabdike>
References: <5885.1372437573@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <5885.1372437573@warthog.procyon.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org, Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-06-28 at 17:39 +0100, David Howells wrote:
> The MN10300 arch is throwing up an error in the SCSI driver and I'm not sure
> whether it needs fixing in the arch - in get_user() - or in the SCSI code.
> 
> The problem is this line in sg_scsi_ioctl():
> 
> 	if (get_user(opcode, sic->data))
> 
> sic points to the following struct:
> 
> 	typedef struct scsi_ioctl_command {
> 		unsigned int inlen;
> 		unsigned int outlen;
> 		unsigned char data[0];
> 	} Scsi_Ioctl_Command;
> 
> However, __get_user_check() on MN10300 does this:
> 
> 	const __typeof__(ptr) __guc_ptr = (ptr);
> 
> which fails with:
> 
> 	block/scsi_ioctl.c:450: error: invalid initializer
> 
> The question is what is SCSI actually asking get_user() to do?  As far as I
> can tell, gcc thinks that it's being askied to declare some sort of array
> here.

I'm surprised you need to ask this.  by convention, an array of char is
usable as a pointer to char *.  The compiler therefore thinks this is a
legitimate conversion which doesn't need a cast:

	unsigned char *d = sic->data;

Therefore, sic->data should be usable as a char * pointer everywhere.

> Should the SCSI driver be changed to:
> 
> 	if (get_user(opcode, (unsigned char *)sic->data))

can we visit reality for a minute?  That proposal would require us to do
an explicit (unsigned char *) conversion everywhere we use an array as a
pointer value ... good grief, no!

> or should the MN10300 arch be changed to morph the array into a pointer,
> perhaps with:
> 
> 	const __typeof__(ptr[0])* __guc_ptr = (ptr);

Neither.  It should do what every other architecture does, which is:

	const __typeof__(*(ptr)) *__guc_ptr = (ptr);

James
