From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Mon, 21 Oct 2002 00:28:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021021072801.GA3197@beaverton.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015194705.GD4391@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Doug Ledford [dledford@redhat.com] wrote:
>     ha = IPS_HA(SDptr->host);
> -   min = ha->max_cmds / 4;
> -   if (min < 8)
> -      min = ha->max_cmds - 1;
> -   scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
> +   if (SDptr->tagged_supported) {
> +      min = ha->max_cmds / 2;
> +      if (min <= 16)
> +         min = ha->max_cmds - 1;
> +      scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
> +   }
>     return 0;
>  }
>  

Doug,
	Sorry I did not get on to checking your version of this patch
	sooner.

I did check 2.5.44 which includes your patched version of ips.c. I am
seeing only a queue depth of 1.

The reason is that the SERVERAID disks are virutal and the inquiry data
they send back does is generated in the driver. The inq data does not
have the CmdQue bit set which results in tagged_supported not being set.

Either the slave_attached code will need to change or the driver will
need to start setting CmdQue.

Output for ServeRAID:
PQual=0, Device type=0, RMB=0, ANSI version=2, [full version=0x02]
AERC=0, TrmTsk=0, NormACA=0, HiSUP=0, Resp data format=2, SCCS=0
BQue=0, EncServ=0, MultiP=0, MChngr=0, ACKREQQ=0, Addr16=1
RelAdr=0, WBus16=1, Sync=1, Linked=0, TranDis=0, CmdQue=0
length=36 (0x24)
Vendor identification: IBM
Product identification: SERVERAID
Product revision level: 1.00


-andmike
--
Michael Anderson
andmike@us.ibm.com

