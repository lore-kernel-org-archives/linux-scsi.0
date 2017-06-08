From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] iscsi-target: Reject immediate data underflow larger than
 SCSI transfer length
Date: Thu, 8 Jun 2017 15:37:34 +0000
Message-ID: <1496936253.3028.1.camel@wdc.com>
References: <1496895685-18464-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496895685-18464-1-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Content-ID: <88F4A4B7C39F01419B37EEBC690F3AF2@namprd04.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "roland@purestorage.com" <roland@purestorage.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-06-08 at 04:21 +0000, Nicholas A. Bellinger wrote:
> +	/*
> +	 * Check for underflow case where both EDTL and immediate data payload
> +	 * exceeds what is presented by CDB's TRANSFER LENGTH, and what has
> +	 * already been set in target_cmd_size_check() as se_cmd->data_length.
> +	 *
> +	 * For this special case, fail the command and dump the immediate data
> +	 * payload.
> +	 */
> +	if (cmd->first_burst_len > cmd->se_cmd.data_length) {
> +		cmd->sense_reason =3D TCM_INVALID_CDB_FIELD;
> +		goto after_immediate_data;
> +	}

A quote from the iSCSI RFC (https://tools.ietf.org/html/rfc5048):

   If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
=A0=A0=A0SCSI Response PDU as specified in [RFC3720].=A0=A0The Residual Cou=
nt MUST
=A0=A0=A0be set to the numerical value of (EDTL - SPDTL).

Sorry but I don't think that sending TCM_INVALID_CDB_FIELD back to the
initiator is compliant with the iSCSI RFC. Please note that a fix that is
compliant with the iSCSI RFC is present in the following patch series: [PAT=
CH
00/33] SCSI target driver patches for kernel v4.13, 23 May 2017
(https://www.spinics.net/lists/target-devel/msg15370.html).

Bart.=
