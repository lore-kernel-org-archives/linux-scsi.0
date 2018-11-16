From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 01:48:10 -0800
Message-ID: <20181116094810.GA23053@infradead.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org>
 <20181111134241.GA2447@thunk.org>
 <20181112082013.GA9307@infradead.org>
 <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
 <20181116093225.GA17033@infradead.org>
 <fa3ed175-13a3-bedf-ebf9-ddf46a2decd5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa3ed175-13a3-bedf-ebf9-ddf46a2decd5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 16, 2018 at 10:45:11AM +0100, Paolo Bonzini wrote:
> Yeah, but looking at the command is what Ted wants.  The thing that we
> did in RHEL was a single sysfs bool that allows unfiltered access,
> because it was sort of enough and made the delta very small.  But for
> upstream I want to do it right, even if that means learning all that
> new-fangled BPF stuff. :)

So what is this magic command?

> I would even agree, however it's allowed right now and I would be
> surprised if no one was relying on it in good faith ("I'm just doing an
> INQUIRY, why do I need to open O_RDWR").  And indeed:
> 
> $ sudo chmod a+r /dev/sda
> $ strace -e openat sg_inq /dev/sda
> openat(AT_FDCWD, "/dev/sda", O_RDONLY|O_NONBLOCK) = 3

Well, not if we only did that for unprivileged opens.
