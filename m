From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] iscsi-target: Fix memory leak if iscsit_alloc_buffs() fails
Date: Fri, 24 Feb 2012 21:19:38 -0800
Message-ID: <CAL1RGDU7ZJ2hRh1tnpofMQcP5LD=y2qhoL0TPGNmB-4OSVLOUw@mail.gmail.com>
References: <1330046923-4034-1-git-send-email-roland@kernel.org> <1330132633.4528.148.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1330132633.4528.148.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 24, 2012 at 5:17 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This looks like a double free here on the second failure of
> iscsit_allocate_iovecs(). =A0Fixing this up now to drop the extra bog=
us
> kfree(cmd->t_mem_sg) here..

I don't see how the patch you committed:

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -830,7 +830,7 @@ page_alloc_failed:
                __free_page(sg_page(&sgl[i]));
                i--;
        }
-       kfree(cmd->t_mem_sg);
+       kfree(sgl);
        cmd->t_mem_sg =3D NULL;
        return -ENOMEM;
 }

could possibly be right... you drop the kfree() of cmd->t_mem_sg but le=
ave
in the "cmd->t_mem_sg =3D NULL".  Isn't that a guaranteed leak of cmd->=
t_mem_sg?

I think the old code was probably OK (although I get lost a bit in the
twisty maze of what exactly happens to the cmd on this failure path), a=
nd
maybe the new code would be OK if you got rid of the "cmd->t_mem_sg =3D=
 NULL".

 - R.
