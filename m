From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] bug fixes for the 53c700 driver in 2.4.19
Date: Mon, 05 Aug 2002 16:12:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208052112.g75LCDG16015@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA25699
	for <linux-scsi@vger.kernel.org>; Mon, 5 Aug 2002 14:12:20 -0700
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

Hi Marcelo,

The attached fixes several nasty bugs in the 53c700 driver which have been 
causing system hangs.  The problems fixed are:

- Tag starvation avoidance would hang
- A 10 byte command would be re-issued as a 6 byte one and thus loop in a 
phase mismatch

This should be a good candidate for an early 2.4.20-pre.

Thanks,

James


You can import this changeset into BK by piping this whole message to:
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.162, 2002-06-09 15:21:17-04:00, jejb@mulgrave.(none)
  [SCSI 53c700] update version to 2.8

ChangeSet@1.161, 2002-06-09 15:21:10-04:00, jejb@mulgrave.(none)
  [SCSI 53c700] bux fix in tag starvation, cosmetic cleanup of set_depth

ChangeSet@1.160, 2002-03-16 11:03:34-05:00, jejb@mulgrave.(none)
  53c700
  
  Correct request sense processing to avoid command retry length
  mismatch.


 53c700.c |   38 +++++++++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 7 deletions(-)


diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Mon Aug  5 16:05:46 2002
+++ b/drivers/scsi/53c700.c	Mon Aug  5 16:05:46 2002
@@ -51,6 +51,14 @@
 
 /* CHANGELOG
  *
+ * Version 2.8
+ *
+ * Fixed bad bug affecting tag starvation processing (previously the
+ * driver would hang the system if too many tags starved.  Also fixed
+ * bad bug having to do with 10 byte command processing and REQUEST
+ * SENSE (the command would loop forever getting a transfer length
+ * mismatch in the CMD phase).
+ *
  * Version 2.7
  *
  * Fixed scripts problem which caused certain devices (notably CDRWs)
@@ -104,7 +112,7 @@
  * Initial modularisation from the D700.  See NCR_D700.c for the rest of
  * the changelog.
  * */
-#define NCR_700_VERSION "2.7"
+#define NCR_700_VERSION "2.8"
 
 #include <linux/config.h>
 #include <linux/version.h>
@@ -676,21 +684,34 @@
 			print_sense("53c700", SCp);
 
 #endif
-			SCp->use_sg = SCp->cmnd[8];
+			/* restore the old result if the request sense was
+			 * successful */
 			if(result == 0)
 				result = SCp->cmnd[7];
+			/* now restore the original command */
+			memcpy((void *) SCp->cmnd, (void *) SCp->data_cmnd,
+			       sizeof(SCp->data_cmnd));
+			SCp->request_buffer = SCp->buffer;
+			SCp->request_bufflen = SCp->bufflen;
+			SCp->use_sg = SCp->old_use_sg;
+			SCp->cmd_len = SCp->old_cmd_len;
+			SCp->sc_data_direction = SCp->sc_old_data_direction;
+			SCp->underflow = SCp->old_underflow;
+			
 		}
 
 		free_slot(slot, hostdata);
-
-		SCp->host_scribble = NULL;
-		SCp->result = result;
-		SCp->scsi_done(SCp);
+#ifdef NCR_700_DEBUG
 		if(NCR_700_get_depth(SCp->device) == 0 ||
 		   NCR_700_get_depth(SCp->device) > NCR_700_MAX_TAGS)
 			printk(KERN_ERR "Invalid depth in NCR_700_scsi_done(): %d\n",
 			       NCR_700_get_depth(SCp->device));
+#endif /* NCR_700_DEBUG */
 		NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) - 1);
+
+		SCp->host_scribble = NULL;
+		SCp->result = result;
+		SCp->scsi_done(SCp);
 	} else {
 		printk(KERN_ERR "53c700: SCSI DONE HAS NULL SCp\n");
 	}
@@ -1050,7 +1071,6 @@
 				 * of the command */
 				SCp->cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
 				SCp->cmnd[7] = hostdata->status[0];
-				SCp->cmnd[8] = SCp->use_sg;
 				SCp->use_sg = 0;
 				SCp->sc_data_direction = SCSI_DATA_READ;
 				pci_dma_sync_single(hostdata->pci_dev,
@@ -1893,6 +1913,10 @@
 				printk(KERN_WARNING "scsi%d (%d:%d) Target is suffering from tag 
starvation.\n", SCp->host->host_no, SCp->target, SCp->lun);
 				NCR_700_set_flag(SCp->device, NCR_700_DEV_TAG_STARVATION_WARNED);
 			}
+			/* Release the slot and ajust the depth before refusing
+			 * the command */
+			free_slot(slot, hostdata);
+			NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) - 1);
 			return 1;
 		}
 		slot->tag = SCp->device->current_tag++;

===================================================================


This BitKeeper patch contains the following changesets:
1.160..1.162
## Wrapped with gzip_uu ##


begin 664 bkpatch15967
M'XL(`*KH3CT``]U847/:1A!^MG[%3OQ0<`W<24(",F228)IZDC@IU'EI.\PA
MG4".T%'="8<./[Z[DL!@,YZFK:>=`&/!W>J[N_UV]UOY%*ZUS'HG-_)F:IW"
MCTJ;WLDB3V:96,EF+56IK./X2"D<;\W50K;(M/7Z;:OM!#YC#;OI6FCQ49A@
M#BN9Z=X);SJ[$;->RM[):/CF^MVKD67U^S"8BW0FQ])`OV\9E:U$$NJ7PLP3
ME39-)E*]D$8T`[78[$PW-F,VOMO<=UC;VW"/N?XFX"'GPN4R9+;;\5QK(;)`
M)NKE,LF#S^MF&&N3*41*96#BE;B/YW#'MKEO^QO6\3S/N@#>1&1@=HLY+>X!
MYSWF]!RWP=H]QH!._O*><^![#@UFO89_]R0#*X#2P?@%/P.597@(R.3ON=0&
MM$RUA&6F`JEUG,YP>1`K%8>`JRU$&J*ER=:0R'1FY@BPB/6""&E:;\'OVK[U
M\8X(J_&5+\MB@EDO8$F(QP\<9C$%0TL'.JY"I1GL#F\S[O/.AMF\S3>^=#M.
M)P@#8=M=P?VC?GX,T.$>NA&9W-BNBT>SC@(\()]N<AQWPPI_E.3S@GROQ;K`
MVSV;]SAK,/<_(/^7\6!\687`;S#-OT`4?X$X!2-FH(W`]4RLTG/DFQ:*`P@2
M*=)\"2K"Z#"34"Z1>"+;[7Q+9'NLR_'==C>NS;M_D>SB)IMS1F2C/TJR[0=D
M^_\'LO-E*(PL:BDR3)EM-SL%DP[_YIA$4C`#W0YW"W$X:DY"\31[_@>PMN.A
M<+0[=K=;A%/[4#;L(I@>DPT;&O:31-.KQ,CL4:7(<$)E$E06S^)4)%O1P)OQ
MVS*11B;K)FQ51X/`"C2#V[G$F\Q<HIJ$D(@U+J."0%"8BB19EYJC$>6%!],U
MQG"%J^$V-G,(%N$$!:GO@8@>;)&$J2S?'Z"1W18?#-F/QT/B;\3^A>=CGEN7
M=+&MDY.3UMG.$70FE9!HZCPQ$$?%R*$+;X6FN^`,=!Z0,Z,\@;,6`G8X<%8A
MINKV$/6>B^D.M%S(1;!<UVJ%9)_583Q8-EX$BS0\A\,Q+`5B4DP4BY<O'?\A
M550[-*C7GY-),5CM?#+-HP@=W2^QRE_'K9"7?3/\>6>7:SG1L^TT^FE2CMQ9
M5,SNFU1#=S8ZF!1[#6.**:ILE35.T`V'DWNKIZ',H@3]NK^![6!A9UUPUG:0
MW.-B\!6M`V6R=R`+O-MKNX_+`H.&^R293$E'LG^H^:`5Q`9")77ZG0'"+4)-
MK[61"ZA-UQ!E4F*N(T0QD2@#94\8YD%<F8=R%0=TP3X!IC*BB,4$SK.4+'B]
M;#S?J]761H0WN38+F1KJ0\B9DQ`]@(V'PF<(JBNT[*18K;9M2Q`"3U"G["[U
M^LFRN^N!B\G8I20_C:-01G`U&$T0<'(Q?'W]QKKT&<7(J4Q#3'#,U8/I(I5]
MYB+(KU85>G-\')KH((NGTT1B^%U=OWOWW-IE3U$K^E71V(WO'$/YB3EYR;NL
MC:AE?1A);-.T/.1%D&,K4@[8B'(JV579H?G#*K+S=XW^G`/ME]*HK`3;X^VZ
MP:I@%+R?[TX_.S9=AP:&P/.O3ZC[[1DEE/^@SWH\H;K0X$^23T<[JY*!$)^<
M"D2L[NCB;$T!2UW)$\7K)=:KCH6L?JHV0ST>G-'(#_$7&<)4A$7^"ZS96!$I
M:0^KP)ZDUY89LJ9RC1J,44(@Y3[A5N4H:_=+!.F;4H"1M"947<+*$"7_58+5
M):(=$,IV$W.QJEJ'4)5:CD5O7^'W=T,_1\.?KH?CGPEC/+P:#Z&V'[WEKA*E
MED"!3AO%*"P.*:"@F52K>G9%B.W#:_'\@SB#]Q>PG&,:85U!GV'U]TG9R\LI
M9GZ,96D;WY^&H_'EARMXAAY^=O>OBF`N@\_(==\7G2`27%I_`B[7)D\,$0``
`
end


