From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Mon, 12 Nov 2018 11:17:29 +0100
Message-ID: <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org> <20181111134241.GA2447@thunk.org>
 <20181112082013.GA9307@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181112082013.GA9307@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 12/11/2018 09:20, Christoph Hellwig wrote:
> On Sun, Nov 11, 2018 at 08:42:42AM -0500, Theodore Y. Ts'o wrote:
>> It really depends on the security model being used on a particular
>> system.  I can easily imagine scenarios where userspace is allowed
>> full access to the device with respect to read/write/open, but the
>> security model doesn't want to allow access to various SCSI commands
>> such as firmware upload commands, TCG commads, the
>> soon-to-be-standardized Zone Activation Commands (which allow dynamic
>> conversion of HDD recording modes between CMR and SMR), etc.
> 
> Well, that's what we have the security_file_ioctl() LSM hook for so that
> your security model can arbitrate access to ioctls.

Doesn't that have TOC-TOU races by design?

Also, what about SG_IO giving write access to files that are only opened
read-only (and only have read permissions)?

Paolo
