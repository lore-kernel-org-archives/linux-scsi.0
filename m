From: David Howells <dhowells@redhat.com>
Subject: SCSI vs MN10300: Can get_user() be given an array?
Date: Fri, 28 Jun 2013 17:39:33 +0100
Message-ID: <5885.1372437573@warthog.procyon.org.uk>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: dhowells@redhat.com, Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
List-Id: linux-scsi@vger.kernel.org


The MN10300 arch is throwing up an error in the SCSI driver and I'm not sure
whether it needs fixing in the arch - in get_user() - or in the SCSI code.

The problem is this line in sg_scsi_ioctl():

	if (get_user(opcode, sic->data))

sic points to the following struct:

	typedef struct scsi_ioctl_command {
		unsigned int inlen;
		unsigned int outlen;
		unsigned char data[0];
	} Scsi_Ioctl_Command;

However, __get_user_check() on MN10300 does this:

	const __typeof__(ptr) __guc_ptr = (ptr);

which fails with:

	block/scsi_ioctl.c:450: error: invalid initializer

The question is what is SCSI actually asking get_user() to do?  As far as I
can tell, gcc thinks that it's being askied to declare some sort of array
here.

Should the SCSI driver be changed to:

	if (get_user(opcode, (unsigned char *)sic->data))

or should the MN10300 arch be changed to morph the array into a pointer,
perhaps with:

	const __typeof__(ptr[0])* __guc_ptr = (ptr);

or:

	const __typeof__(*ptr)* __guc_ptr = (ptr);

David
