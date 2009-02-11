From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2.6.29-rc] iscsi - add offset and count to alloc_pdu()
Date: Wed, 11 Feb 2009 10:21:50 +0200
Message-ID: <49928A9E.5070600@Voltaire.com>
References: <200902110301.n1B31q5M002101@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <200902110301.n1B31q5M002101-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Karen Xie wrote:
> So I only added the offset and count as additional parameters to alloc_pd=
u().=20
> So that the pdu payload is known at the time of pdu memory allocation.
>  include/scsi/libiscsi.h             |   12 +++++
>  include/scsi/scsi_transport_iscsi.h |    3 +

Hi Karen,

Please take into account that the iscsi transport and libiscsi APIs has mor=
e consumers that are effects by changes. For example iSER also uses the all=
oc_pdu API and your patch should take care of that. I would recommend addin=
g the needed CONFIG directives the other iSCSI transports to your default .=
config profile which will allow you to catch such issues. Building Linus tr=
ee with your patch I see warning both in the cxgbi and iser drivers wrt to =
the change.

Or.

[root@linux-cto-1 linus-linux-2.6]# make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC [M]  drivers/infiniband/ulp/iser/iscsi_iser.o
drivers/infiniband/ulp/iser/iscsi_iser.c:656: warning: initialization from =
incompatible pointer type
  LD [M]  drivers/infiniband/ulp/iser/ib_iser.o
  CC [M]  drivers/scsi/cxgb3i/cxgb3i_iscsi.o
drivers/scsi/cxgb3i/cxgb3i_iscsi.c:913: warning: initialization from incomp=
atible pointer type
  LD [M]  drivers/scsi/cxgb3i/cxgb3i.o
Kernel: arch/x86/boot/bzImage is ready  (#3)
  Building modules, stage 2.
  MODPOST 514 modules
  LD [M]  drivers/infiniband/ulp/iser/ib_iser.ko
  LD [M]  drivers/scsi/cxgb3i/cxgb3i.ko

the config directives for iser and ql4xxx are CONFIG_SCSI_QLA_ISCSI=3Dm and=
 CONFIG_INFINIBAND_ISER=3Dm
for iser you would also need CONFIG_INFINIBAND=3Dm and CONFIG_INFINIBAND_AD=
DR_TRANS=3Dy
