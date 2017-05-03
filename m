From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Wed, 3 May 2017 16:18:03 +0000
Message-ID: <1493828282.3901.9.camel@sandisk.com>
References: <20170502174330.13146-1-bart.vanassche@sandisk.com>
         <20170503075416.GA10084@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170503075416.GA10084@quack2.suse.cz>
Content-Language: en-US
Content-ID: <4194EF592024574C86C88F21F2B45E8C@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "jack@suse.cz" <jack@suse.cz>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "scott.bauer@intel.com" <scott.bauer@intel.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-05-03 at 09:54 +0200, Jan Kara wrote:
> Hum, since this didn't quite work out, how about storing that one bit of
> information that scsi_exit_rq() needs from shost inside scsi_cmnd during
> scsi_init_rq()?

Hello Jan,

All what's missing from the patch I posted is a execute_in_process_context(=
)
scsi_host_dev_release() call execute in a context where sleeping is allowed=
.
What you proposed is something I had considered but that I had not yet trie=
d
to implement because it requires more changes. Anyway, I'll give that appro=
ach
a try since it does not require to introduce a new work_struct.

Bart.=
