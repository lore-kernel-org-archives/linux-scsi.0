From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 10:45:11 +0100
Message-ID: <fa3ed175-13a3-bedf-ebf9-ddf46a2decd5@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org> <20181111134241.GA2447@thunk.org>
 <20181112082013.GA9307@infradead.org>
 <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
 <20181116093225.GA17033@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181116093225.GA17033@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 16/11/18 10:32, Christoph Hellwig wrote:
> On Mon, Nov 12, 2018 at 11:17:29AM +0100, Paolo Bonzini wrote:
>>> Well, that's what we have the security_file_ioctl() LSM hook for so that
>>> your security model can arbitrate access to ioctls.
>>
>> Doesn't that have TOC-TOU races by design?
> 
> If you want to look at the command - yes.  If you just want to filter
> read vs write vs ioctl, no.

Yeah, but looking at the command is what Ted wants.  The thing that we
did in RHEL was a single sysfs bool that allows unfiltered access,
because it was sort of enough and made the delta very small.  But for
upstream I want to do it right, even if that means learning all that
new-fangled BPF stuff. :)

>> Also, what about SG_IO giving write access to files that are only opened
>> read-only (and only have read permissions)?
> 
> Allowing SG_IO on read-only permissions sounds like a reall bad idea,
> filtering or not.

I would even agree, however it's allowed right now and I would be
surprised if no one was relying on it in good faith ("I'm just doing an
INQUIRY, why do I need to open O_RDWR").  And indeed:

$ sudo chmod a+r /dev/sda
$ strace -e openat sg_inq /dev/sda
openat(AT_FDCWD, "/dev/sda", O_RDONLY|O_NONBLOCK) = 3
                             ^^^^^^^^

So it would be a regression.

Paolo
