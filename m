From: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Subject: Re: [PATCH v4 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Wed, 1 Jun 2016 16:21:01 -0700
Message-ID: <CAMP5Xgfo-4h3DYki0VWhQFjBtAE9=f9dqCZQV8VDvfJ3Rc_2UQ@mail.gmail.com>
References: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 1, 2016 at 2:41 PM, Tomas Winkler <tomas.winkler@intel.com>=
 wrote:
> Few storage technology such is EMMC, UFS, and NVMe support RPMB
> hardware partition with common protocol and frame layout.
> The RPMB partition cannot be accessed via standard block layer, but
> by a set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
> PROGRAM_KEY.
>...

If the same protocol is used by all these standards, why not export it
directly (including the RESULT_READ command or not even knowing the
command types)? While I would prefer an rpmb specific interface over
the existing raw mmc command interface, all I need is an rpmb
operation that lets me send and receive buffers without interruption.
You can find our exiting user-space code here at
https://android.googlesource.com/platform/system/core/+/master/trusty/s=
torage/proxy/rpmb.c.
If you use an interface more similar to this, I think your emmc and
ufs specific code would be simpler. Also, if you don't need the
in-kernel interface, the kernel would not need to know the details of
the rpmb protocol at all.

I have not tested your code, but it looks like we would have to modify
the storage proxy to interpret the data it currently passes through
and remove all RESULT_READ packets.

--=20
Arve Hj=C3=B8nnev=C3=A5g
