From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to the
 tcm_qla2xxx module - revision3
Date: Wed, 30 Mar 2016 22:34:13 -0700
Message-ID: <1459402453.31390.45.camel@haakon3.risingtidesystems.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com>
	 <56FB5E98.9010103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56FB5E98.9010103@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

(Adding target-devel + Qlogic target folks)

On Tue, 2016-03-29 at 22:05 -0700, Bart Van Assche wrote:
> On 03/29/16 07:42, Laurence Oberman wrote:
> > I have been using this jammer functionality to continue testing the SCSI F/C drivers and recovery for over a year now.
> > Any chance you would agree to ack this so I can get it in now.
> > I last posted to the list last March and it was not picked up.
> >
> > I did look into moving this to upper layers but I find I use it primarily for fiber channel target testing.
> > Attempting to add this functionality to upper layers led to complexities and this is very solid.
> >
> > This Patch diff against 4.5
> >
> > I use target LIO for all my storage array test targets and customer problem resolution here at Red Hat.
> > This patch resulted from a requirement to mimic behavior of an expensive hardware jammer for a customer.
> > I have used this for some time with good success to simulate and reproduce latency and slow drain fabric issues and
> > for testing and validating error handling behavior
> >   in the Emulex, Qlogic and other F/C drivers.
> >
> > Works by checking new parameter jam_host if its >= 0 and matches vha->host_no , jamming is enabled when jam_host >=0
> > If parameter set to -1 (default) no jamming is enabled.
> 
> Hello Laurence,
> 
> Nic Bellinger is the maintainer of LIO so my recommendation is to ask 
> Nic first about his opinion (I have CC'd Nic). I'm not sure what Nic 
> thinks about this but in my opinion such functionality belongs in the 
> target core instead of in a target driver. But please wait until Nic has 
> provided his opinion before spending more time on this. The mailing list 
> for SCSI target patches is target-devel@vger.kernel.org.
> 

So really it's Himanshu's + Quinn's call if they would like to include
something like this in mainline.

If so, then I'd prefer to do it with a per tcm_qla2xxx_tpg endpoint
attribute instead a new module parameter, and add a new kernel config
option (CONFIG_TCM_QLA2XXX_DEBUG) to disable (by default) so end users
don't inadvertently play with it via targetcli + friends.
