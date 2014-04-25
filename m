From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 3.15-rc3
Date: Fri, 25 Apr 2014 15:53:35 -0700
Message-ID: <CA+55aFwtF=PSrixQg7+=bhmB_6hDheykBpU2pYMGE6+zNQz=Sg@mail.gmail.com>
References: <1398437960.2159.4.camel@dabdike.int.hansenpartnership.com>
	<alpine.DEB.2.02.1404251547020.6936@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404251547020.6936@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 25, 2014 at 3:49 PM, David Rientjes <rientjes@google.com> wrote:
>
> Hmm, I see why this is needed because of the scsi_put_command(cmd), but I
> think you need to do struct scsi_device *sdev = ACCESS_ONCE(cmd->device)
> instead to prevent gcc from messing with the code generation.

No, if gcc were to move the access to 'cmd' to after the
'scsi_put_command(cmd)', that would be a major compiler bug.

Compilers can't just randomly move code around, guys.

            Linus
