From: Roland Dreier <roland@purestorage.com>
Subject: Re: [RFC-v4 1/3] qla2xxx: Add LLD internal target-mode support
Date: Wed, 21 Dec 2011 14:46:46 -0800
Message-ID: <CAL1RGDW6NVcx0PQzm+FRHRWdrYwKshV6z2i3oCbJqvDhV6t8rQ@mail.gmail.com>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
 <1324173746-14361-2-git-send-email-nab@linux-iscsi.org> <CAL1RGDXPmRfLsRgVYyYVNo-3iE-oKHANAB-3Zy6_GNgVONCiQw@mail.gmail.com>
 <1324504132.22016.21.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1324504132.22016.21.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2011 at 1:48 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> So looking at qla_tgt-3.3, qla_target.c:2591 lines up with the
> following:
>
> void qla_tgt_free_cmd(struct qla_tgt_cmd *cmd)
> {
> =A0 =A0 =A0 =A0BUG_ON(cmd->sg_mapped);
>
> =A0 =A0 =A0 =A0if (unlikely(cmd->free_sg))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(cmd->sg);
> =A0 =A0 =A0 =A0kmem_cache_free(qla_tgt_cmd_cachep, cmd);
> }

Sorry, yeah, grabbed the wrong chunk when quoting your mail.

This is the real BUG we're hitting.

 - R.
