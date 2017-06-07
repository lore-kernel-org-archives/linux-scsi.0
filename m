From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 01/15] qla2xxx: Combine Active command arrays.
Date: Wed, 7 Jun 2017 22:45:11 +0000
Message-ID: <1496875510.27975.1.camel@wdc.com>
References: <20170607214333.23110-1-himanshu.madhani@cavium.com>
         <20170607214333.23110-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170607214333.23110-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <9A8C21A5DA8C164B84D1641C8BDED9C5@namprd04.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-06-07 at 14:43 -0700, Himanshu Madhani wrote:
> +enum {
> +	TYPE_SRB,
> +	TYPE_TGT_CMD,
> +};
> +
>  typedef struct srb {
> +	/*
> +	 * Do not move cmd_type field, it needs to
> +	 * line up with qla_tgt_cmd->cmd_type
> +	 */
> +	uint8_t cmd_type;
> +	uint8_t pad[3];
>  	atomic_t ref_count;
>  	struct fc_port *fcport;
>  	struct scsi_qla_host *vha;

[ ... ]
=20
>  struct qla_tgt_cmd {
> +	/*
> +	 * Do not move cmd_type field. it needs to line up with srb->cmd_type
> +	 */
> +	uint8_t cmd_type;
> +	uint8_t pad[7];
>  	struct se_cmd se_cmd;
>  	struct fc_port *sess;
>  	int state;

Hello Quinn and Himanshu,

Sorry but this is really inelegant. Have you considered the following?
- Keep the existing srb and qla_tgt_cmd data structures.
- Introduce a new data structure with enum cmd_type as the first member and
  a union of struct srb and struct qla_tgt_cmd as the second member.
- Use __attribute__((aligned(...))) to express alignment requirements inste=
ad
  of explicitly inserting padding bytes.

With that approach no casts are needed to convert a pointer to the new data
structure into a struct srb or struct qla_tgt_cmd pointer - all that will b=
e
needed is to take the address of the appropriate member of the union.

Thanks,

Bart.=
