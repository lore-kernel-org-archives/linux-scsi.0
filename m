From: Vikas Chaudhary <vikas.chaudhary-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [RFC-V2 PATCH 2/5] qla4xxx: add support for set_net_config
Date: Wed, 13 Apr 2011 07:40:20 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A8CB61F@AVEXMB1.qlogic.org>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1301769261-29896-3-git-send-email-vikas.chaudhary@qlogic.com>
 <4DA51ECA.1020507@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncCOOu1pfXHxDg65btBBoEic04yw-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <4DA51ECA.1020507-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Language: en-US
To: "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: "James.Bottomley-l3A5Bk7waGM@public.gmane.org" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lalit Chandivade <lalit.chandivade-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Ravi Anand <ravi.anand-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Harish Zunjarrao <harish.zunjarrao-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org [mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org] On
>Behalf Of Mike Christie
>Sent: Wednesday, April 13, 2011 9:26 AM
>To: Vikas Chaudhary
>Cc: James.Bottomley-l3A5Bk7waGM@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; open-
>iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org; Lalit Chandivade; Ravi Anand; Harish Zunjarrao
>Subject: Re: [RFC-V2 PATCH 2/5] qla4xxx: add support for set_net_config
>
>On 04/02/2011 01:34 PM, vikas.chaudhary-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org wrote:
>>
>> +/* Only for primary ACB, secondary ACB not supported
>> + * iface_num =3D 0: valid ->  linklocal, routable, router, autocfg opti=
ons
>> + * iface_num =3D 1: valid ->  routable
>> + */
>> +static inline void qla4xxx_set_ipv6(struct iscsi_net_param *net_param,
>> +            struct addr_ctrl_blk *init_fw_cb)
>> +{
>> +    switch (net_param->param_type) {
>> +    case ISCSI_NET_PARAM_IPV6_ADDR:
>> +            if (net_param->iface_num&  0x1) {
>
>Is this my mailer?
>
>I think you want to check for iface_num =3D=3D 1. Above in the function
>comments and in other places you set the iface_num as a int, but in this
>function you check it more like a bitmask.
>

We want to check even interface here.
I will update code to make iface_num data type to uint8_t.

>
>> +    case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
>> +            if (net_param->iface_num&  0x1)
>
>> +    case ISCSI_NET_PARAM_IPV6_ROUTER:
>> +            if (net_param->iface_num&  0x1)
>
>
>> +    case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
>> +            /* Autocfg applies to even interface */
>> +            if (net_param->iface_num&  0x1)
>
>However, in other places you have that comment about even applying to
>autocfg interfaces.

QLogic adapter supports two IPv6 addresses per port and both address
can be either autocfg or user specified. However autocfg setting is
common for both the addresses, that's reason we update autocfg from
even interface only.

Also both IPv6 addresses will have same linklocal addr and same
router address.

Transport code is written in way that if someone wants to support individua=
l
configuration (autocfg, linklocal addr, etc) for each iface, they can do it=
.

>
>Why does it say even but you only support 2 ipv6 ifaces in the  patches?
>Can you support more? Are you coding it in preparation for more?
>

We are supporting only two IPv6 addresses in our driver for now. In future
we may support more. Transport code is scalable to support up to 10 iface p=
er port.

>
>.....
>
>
>
>> +
>> +static int
>> +qla4xxx_set_net_config(struct Scsi_Host *shost, char *data, int count)
>> +{
>> +    struct scsi_qla_host *ha =3D to_qla_host(shost);
>> +    int rval =3D 0;
>> +    struct iscsi_net_param *net_param =3D NULL;
>> +    struct addr_ctrl_blk *init_fw_cb =3D NULL;
>> +    dma_addr_t init_fw_cb_dma;
>> +
>> +    struct addr_ctrl_blk *acb =3D NULL;
>> +    dma_addr_t acb_dma;
>> +    uint32_t ddb_state;
>> +    struct ddb_entry *ddb_entry, *ddbtemp;
>> +    unsigned long wait_time;
>> +
>> +    uint32_t mbox_cmd[MBOX_REG_COUNT];
>> +    uint32_t mbox_sts[MBOX_REG_COUNT];
>> +    uint32_t total_param_count;
>> +    uint32_t length;
>> +
>> +    init_fw_cb =3D dma_alloc_coherent(&ha->pdev->dev,
>> +        sizeof(struct addr_ctrl_blk),&init_fw_cb_dma, GFP_KERNEL);
>> +    if (!init_fw_cb) {
>> +            printk(KERN_ERR
>> +                "scsi(%ld): %s: Unable to alloc init_cb\n",
>> +                ha->host_no, __func__);
>
>ql4_printk instead of printk. Check in other parts of patches too.
>
>And remember to remove debugging printks or make what looking debug
>printks more informative and use ql4_printk.
>
Ok.

>
>When we set the net settings we reset the port, right? What is the max
>length of time that could take? Like if you set DHCP, do we wait for
>that to timeout and what is longest we wait?

We do not need to reset the adapter, we just disable and enable FW
Settings (Address control block) which will apply new network
configuration to the port.

But before applying new network configuration we need to logout
all active session so we are waiting up to 10sec for each session
to logout.

>
>It was orignally designed to be singled threaded non blocking, so you
>are stopping everything here.
>

We are waiting for session to logout as I mentioned above.

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe@google=
groups.com.
For more options, visit this group at http://groups.google.com/group/open-i=
scsi?hl=3Den.
