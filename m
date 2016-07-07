From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] libata-scsi: introducing SANITIZE translation
Date: Thu, 07 Jul 2016 09:47:34 -0700
Message-ID: <1467910054.2322.7.camel@HansenPartnership.com>
References: <577e843e.0a86620a.59167.ffffb899@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577e843e.0a86620a.59167.ffffb899@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org, martin.petersen@oracle.com, dgilbert@interlog.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-07-08 at 00:32 +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> With this patch, users can make use of the SANITIZE DEVICE feature
> set through utility like sg_sanitize.
> 
> Support for BLOCK ERASE, CRYPTOGRAPHIC ERASE and EXIT FAILURE MODE
> has been implemented. Support for OVERWRITE that involves a
> parameter list has been left out for now.
> 
> Further support for command with IMMED bit set to zero, REQUEST
> SENSE translation for user-space status polling, and support
> checking in IDENTIFY DEVICE data log (return proper sense data
> when designated method is not supported) should be implemented
> in the future as well.
> 
> `sg_sanitize -e -B|-C|-F /dev/sdX` should work fine with this.

Why on earth would you want to do this?  If your intent is to sanitise
the disk using a cryptographic erase you presumably have a real
security need for doing it and, knowing what goes into most SAT layers,
I'd not really trust any SAT for this operation, so for an underlying
SATA device I'd use ATA_16 to send a real ACS-2 SANITIZE command.

Just as a general note about our SAT layer: Adding little used features
is an invitation to bloat it with buggy implementations which makes it
harder to understand and bug prone for odd and unlikely use cases,
which then take ages to diagnose and track down.  The only things which
should be in the SAT is what the Linux SCSI subsystem would actually
use.  For everything else, if the user cares enough, they'll send down
an encapsulated ATA command.

James


