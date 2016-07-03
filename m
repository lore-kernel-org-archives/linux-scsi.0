From: Sumit Rai <sumitrai96@gmail.com>
Subject: Re [PATCH RFC]: LIO seems to use SCSI Allocation Length instead of
 SPDTL for calculating ResidualCount
Date: Sun, 3 Jul 2016 19:24:26 +0530
Message-ID: <20160703135311.GA9339@srai-VirtualBox>
References: <C4B98CC8-8D72-4AF2-B662-C63DE0E7F0D7@calsoftinc.com>
 <9FBEB2CB-389F-41AC-8A95-DADD1A62AB88@calsoftinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9FBEB2CB-389F-41AC-8A95-DADD1A62AB88@calsoftinc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, ajaynair59@gmail.com, sumit.rai@calsoftinc.com
List-Id: linux-scsi@vger.kernel.org

> From: Sumit Rai <sumit.rai@calsoftinc.com>
> Subject: LIO seems to use SCSI Allocation Length instead of SPDTL for=
 calculating ResidualCount
> Date: June 22, 2016 at 7:43:50 PM GMT+5:30
> To: target-devel@vger.kernel.org
>=20
> We are trying to test if LIO target sets ResidualCount correctly in c=
ase of ResidualOverflow for Data-In by following the below Steps:
> 1. Send SCSI Inquiry command to iSCSI target, if there are no excepti=
ons in the response (and no residual overflow) we are able to determine=
 how many bytes the target SCSI layer on target side attempted to trans=
fer to target iSCSI layer. On the initiator side when response is recei=
ved: in the absence of any exceptions or residual overflow we assume al=
l the data was successfully transferred and is equal to iSCSI DataSegme=
ntLength. We will use this value as SPDTL for SCSI Inquiry command.
>=20
> Note: SPDTL is detailed in RFC 7143 11.4.5.2 (and you may also refer =
to discussion on T10 mailing list: http://www.t10.org/pipermail/t10/201=
4-June/017367.html).
>=20
> 2. Send out the same SCSI inquiry command as in Step 1. but set iSCSI=
 EDTL to a value lower than SPDTL.
>=20
> Assumption: Since we are not making any changes to iSCSI target LU co=
nfiguration in our setup b/w Step 1. and 2, we assume amount of Inquiry=
 Data target generates will be same of 1. and 2. since inquiry command =
is the same. During our testing we find this assumption to be true.
>=20
> Expected Result:
> Since in Step 2, SPDTL > EDTL, iSCSI target is expected to set Residu=
alOverflow flag and ResidualCount to SPDTL - EDTL.
> In the attached PCAP text file, frame no. 11 (SCSI Inquiry Req.) and =
12 (Inquiry Response) are for Step 1. As explained, SPDTL =3D 0x24 or 3=
6D.
> Frame no. 14 is for (SCSI Inq. Req.) Step 2. EDTL =3D 0x08.
> Hence, expected ResidualCount =3D 0x1C (28D) i.e. 0x24 (36D) - 0x08 (=
8D)
>=20
> Observed Result:
> iSCSI target sets the Residual Overflow flag correctly but value of R=
esidualCount doesn=E2=80=99t match expected value.
> Target is setting, ResidualCount to 0x3f8 (1016D) as seen in frame no=
 16. In the frame no. 14, in the SCSI Inquiry CDB allocation length (SP=
C 5r01 Section 4.2.5.6) was set to 0x0400 (1024D) and target seems to b=
e using this value to calculate ResidualCount i.e. 0x0400 (1024D) - 0x0=
8.
> To further verify this we  changed the allocation length value in SCS=
I Inquiry CDB to 0x0200 (512D) bytes instead, we get ResidualCount of 0=
x1f8 (504D).
>=20
> Allocation Length is the maximum value of the SPDTL and not substitut=
e for it, hence it shouldn=E2=80=99t be used to calculate ResidualCount=
 except for cases where SPDTL > Allocation Length and Data is truncated=
 (in that case both Alloc Len and SPDTL are same). (SPC 5r01 Section 4.=
2.5.6).
>=20
> LIO Version: Datera Inc. iSCSI Target v4.1.0
> Linux Kernel: 4.4.0-22-generic
>=20
> RFC 7143:
>=20
> 11.4.5.2.  Residuals Concepts Overview
>=20
>=20
>   "SCSI-Presented Data Transfer Length (SPDTL)" is the term this
>   document uses (see=20
> Section 2.2
> for definition) to represent the
>   aggregate data length that the target SCSI layer attempts to transf=
er
>   using the local iSCSI layer for a task.  "Expected Data Transfer
>=20
>   Length (EDTL)" is the iSCSI term that represents the length of data
>   that the iSCSI layer expects to transfer for a task.  EDTL is
>   specified in the SCSI Command PDU.
>=20
>   When SPDTL =3D EDTL for a task, the target iSCSI layer completes th=
e
>   task with no residuals.  Whenever SPDTL differs from EDTL for a tas=
k,
>   that task is said to have a residual.
>=20
>   If SPDTL > EDTL for a task, iSCSI Overflow MUST be signaled in the
>   SCSI Response PDU as specified in=20
> Section 11.4.5.1
> .  The Residual
>   Count MUST be set to the numerical value of (SPDTL - EDTL).
>=20
>   If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
>   SCSI Response PDU as specified in=20
> Section 11.4.5.1
> .  The Residual
>   Count MUST be set to the numerical value of (EDTL - SPDTL).
>=20
>   Note that the Overflow and Underflow scenarios are independent of
>   Data-In and Data-Out.  Either scenario is logically possible in
>=20
>=20
> SPC 5r01
> 4.2.5.6 Allocation length
>=20
> The ALLOCATION LENGTH field specifies the maximum number of bytes or =
blocks that an application client has allocated in the Data-In Buffer. =
The ALLOCATION LENGTH field specifies bytes unless a different requirem=
ent is stated in the command definition.
>=20
> An allocation length of zero specifies that no data shall be transfer=
red. This condition shall not be considered an error.
>=20
> The device server shall terminate transfers to the Data-In Buffer whe=
n the number of bytes or blocks specified by the ALLOCATION LENGTH fiel=
d have been transferred or when all available data have been transferre=
d, whichever is less. The allocation length is used to limit the maximu=
m amount of variable length data (e.g., mode data, log data, diagnostic=
 data) returned to an application client. If the information being tran=
sferred to the Data-In Buffer includes fields containing counts of the =
number of bytes in some or all of the data (e.g., a PARAMETER DATA LENG=
TH field, a PAGE LENGTH field, a DESCRIPTOR LENGTH field, an AVAILABLE =
DATA field), then the contents of these fields shall not be altered to =
reflect the truncation, if any, that results from an insufficient ALLOC=
ATION LENGTH value, unless the standard that describes the Data-In Buff=
er format states otherwise.
>=20
> If the amount of information that is available to be transferred exce=
eds the maximum value that the ALLOCATION LENGTH field in combination w=
ith other fields in the CDB is capable of specifying, then no data shal=
l be transferred and the command shall be terminated with CHECK CONDITI=
ON status, with the sense key set to ILLEGAL REQUEST, and the additiona=
l sense code set to INVALID FIELD IN CDB.=20

I havn't received any comments on this issue, I guess the maintainer(s)=
 are occpied with
other high priority issues, so I tried to fix the issue. I have success=
fully tested
the patch and it calculates the residual count as expected. I would app=
reciate it if someone
can do a review of the below patch:

--- linux/drivers/target/target_core_transport.c.orig	2016-07-03 18:09:=
28.949281611 +0530
+++ linux/drivers/target/target_core_transport.c	2016-07-03 18:10:44.00=
7293696 +0530
@@ -754,7 +754,15 @@ EXPORT_SYMBOL(target_complete_cmd);
=20
 void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_statu=
s, int length)
 {
-	if (scsi_status =3D=3D SAM_STAT_GOOD && length < cmd->data_length) {
+	if (scsi_status !=3D SAM_STAT_GOOD) {
+		return;
+	}
+
+	/*
+	 * Calculate new residual count based upon length of SCSI data
+	 * transferred.
+	 */
+	if (length < cmd->data_length) {
 		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			cmd->residual_count +=3D cmd->data_length - length;
 		} else {
@@ -763,6 +771,12 @@ void target_complete_cmd_with_length(str
 		}
=20
 		cmd->data_length =3D length;
+	} else if (length > cmd->data_length) {
+		cmd->se_cmd_flags |=3D SCF_OVERFLOW_BIT;
+		cmd->residual_count =3D length - cmd->data_length;
+	} else {
+		cmd->se_cmd_flags &=3D ~(SCF_OVERFLOW_BIT | SCF_UNDERFLOW_BIT);
+		cmd->residual_count =3D 0;
 	}
=20
 	target_complete_cmd(cmd, scsi_status);
Signed-off-by: Sumit Rai <sumitrai96@gmail.com>

Thanks to Ajay Nair in assisting with this patch.

Thanks,
Sumit Rai
