From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Mon, 12 Nov 2018 00:20:13 -0800
Message-ID: <20181112082013.GA9307@infradead.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org>
 <20181111134241.GA2447@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181111134241.GA2447@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 11, 2018 at 08:42:42AM -0500, Theodore Y. Ts'o wrote:
> It really depends on the security model being used on a particular
> system.  I can easily imagine scenarios where userspace is allowed
> full access to the device with respect to read/write/open, but the
> security model doesn't want to allow access to various SCSI commands
> such as firmware upload commands, TCG commads, the
> soon-to-be-standardized Zone Activation Commands (which allow dynamic
> conversion of HDD recording modes between CMR and SMR), etc.

Well, that's what we have the security_file_ioctl() LSM hook for so that
your security model can arbitrate access to ioctls.
