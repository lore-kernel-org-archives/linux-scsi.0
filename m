From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH] dead code and missing statics in lpfc
Date: Tue, 8 Jun 2004 10:45:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9464@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3712 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S265207AbUFHOp1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 10:45:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph,

We had not completed the effort relative to the comments. Sorry you thought
your patch was ignored. They (including the prior one) was not.

I believe that this week we will have completely dealt with the statics and
symbols. One caveat though.. we have a lot of diagnostic and test tools that
like to do low level error injection, testing, and data sampling. Our
automated test suites are built heavily on this infrastructure. The way we
are approaching these tools is as a separate kernel module. Therefore, the
tools use quite a few of the "dead" symbols/functions. One of our jobs is to
ensure that, where we sliced the interface between the driver and the tool
module, that we did so appropriately, dead code in the driver should
actually be in the tool module, and that we are exporting the minimum number
of symbols. I am pushing to have this completed for the next drop as well,
so we can put these comments to rest.

-- james

PS: The drop on SF was updated with the DOS CR's removed.
PSv2: Added to the work list. I believe the work is complete and should be
in next drop.


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, June 06, 2004 4:47 AM
> To: Christoph Hellwig
> Cc: Smart, James; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] dead code and missing statics in lpfc
> 
> 
> On Mon, May 31, 2004 at 12:04:54PM +0200, Christoph Hellwig wrote:
> > 
> >  - remove dead EXPORT_SYMBOLS
> >  - mark everything static that can be (thanks to Tridge's 
> findstatic.pl)
> >  - kill all dead functions
> > (- small lpfc_evt_iocb_free fixes that sneaked into the context)
> 
> resend of the patch after you nicely broke it with random 
> changes in today
> code drop.
> 
> p.s. it seems emulex let some windows drone make the tarball, 
> it's completely
>  fscked up with broken dos line endings
> p.s. v2  the fs attribute and sysfs support in the tarball is 
> completely
> bullshit.  take a look at what qlogic does and fix it up.
> 
> 
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_crtn.h 
> lpfcdriver-2.6-8.0.3.hch/lpfc_crtn.h
> --- lpfcdriver-2.6-8.0.3/lpfc_crtn.h	2004-06-06 
> 18:48:59.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_crtn.h	2004-06-06 
> 10:36:33.024158344 +0200
> @@ -74,11 +74,6 @@ int lpfc_no_rpi(struct lpfc_hba *, struc
>  int lpfc_freenode(struct lpfc_hba *, struct lpfc_nodelist *);
>  int lpfc_nlp_remove(struct lpfc_hba *, struct lpfc_nodelist *);
>  struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_hba *, 
> uint32_t, uint32_t);
> -struct lpfc_nodelist *lpfc_findnode_scsiid(struct lpfc_hba 
> *, uint32_t);
> -struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_hba *, uint32_t,
> -				    struct lpfc_name *);
> -struct lpfc_nodelist *lpfc_findnode_wwnn(struct lpfc_hba *, uint32_t,
> -				    struct lpfc_name *);
>  void lpfc_disc_list_loopmap(struct lpfc_hba *);
>  void lpfc_disc_start(struct lpfc_hba *);
>  void lpfc_disc_flush_list(struct lpfc_hba *);
> @@ -118,9 +113,6 @@ int lpfc_issue_els_prli(struct lpfc_hba 
>  int lpfc_issue_els_adisc(struct lpfc_hba *, struct 
> lpfc_nodelist *, uint8_t);
>  int lpfc_issue_els_logo(struct lpfc_hba *, struct 
> lpfc_nodelist *, uint8_t);
>  int lpfc_issue_els_scr(struct lpfc_hba *, uint32_t, uint8_t);
> -struct lpfc_iocbq *lpfc_prep_els_iocb(struct lpfc_hba *, 
> uint8_t expectRsp,
> -				      uint16_t, uint8_t, struct 
> lpfc_nodelist *,
> -				      uint32_t);
>  int lpfc_els_free_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
>  void lpfc_cmpl_els_flogi(struct lpfc_hba *, struct lpfc_iocbq *,
>  			 struct lpfc_iocbq *);
> @@ -166,8 +158,6 @@ void lpfc_handle_latt(struct lpfc_hba *)
>  void lpfc_hba_init(struct lpfc_hba *);
>  int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring 
> *, int, int);
>  void lpfc_cleanup(struct lpfc_hba *, uint32_t);
> -int lpfc_online(struct lpfc_hba *);
> -int lpfc_offline(struct lpfc_hba *);
>  int lpfc_scsi_free(struct lpfc_hba *);
>  int lpfc_parse_binding_entry(struct lpfc_hba *, uint8_t *, uint8_t *,
>  			     int, int, int, unsigned int *, int, int *);
> @@ -215,7 +205,6 @@ int lpfc_sli_intr(struct lpfc_hba *);
>  int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
>  int lpfc_sli_issue_iocb(struct lpfc_hba *, struct lpfc_sli_ring *,
>  			struct lpfc_iocbq *, uint32_t);
> -int lpfc_sli_brdreset(struct lpfc_hba *);
>  void lpfc_sli_pcimem_bcopy(uint32_t *, uint32_t *, uint32_t);
>  int lpfc_sli_ringpostbuf_put(struct lpfc_hba *, struct 
> lpfc_sli_ring *,
>  			     DMABUF_t *);
> @@ -240,22 +229,14 @@ void lpfc_start_timer(struct lpfc_hba *,
>  void lpfc_stop_timer(struct clk_data *);
>  
>  
> -int lpfc_sli_issue_iocb_wait(struct lpfc_hba *, struct 
> lpfc_sli_ring *,
> -			     struct lpfc_iocbq *, uint32_t, 
> struct lpfc_iocbq *,
> -			     uint32_t);
>  LPFC_SCSI_BUF_t *lpfc_get_scsi_buf(struct lpfc_hba *);
>  void lpfc_free_scsi_buf(LPFC_SCSI_BUF_t *);
>  void lpfc_map_fcp_cmnd_to_bpl(struct lpfc_hba *, LPFC_SCSI_BUF_t *);
>  void lpfc_free_scsi_cmd(LPFC_SCSI_BUF_t *);
>  uint32_t lpfc_os_timeout_transform(struct lpfc_hba *, uint32_t);
> -int lpfc_scsi_lun_reset(LPFC_SCSI_BUF_t *, struct lpfc_hba 
> *, uint32_t);
> -int lpfc_scsi_tgt_reset(LPFC_SCSI_BUF_t *, struct lpfc_hba 
> *, uint32_t);
>  
>  struct lpfc_hba *lpfc_get_phba_by_inst(int);
>  
> -struct lpfc_bindlist *lpfc_assign_scsid(struct lpfc_hba *,
> -					struct lpfc_nodelist *, int);
> -
>  void lpfc_sched_init_hba(struct lpfc_hba *, uint16_t);
>  void lpfc_sched_target_init(LPFCSCSITARGET_t *, uint16_t);
>  void lpfc_sched_lun_init(LPFCSCSILUN_t *, uint16_t);
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_ct.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_els.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_els.c
> --- lpfcdriver-2.6-8.0.3/lpfc_els.c	2004-06-06 
> 18:48:59.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_els.c	2004-06-06 
> 10:29:04.543337792 +0200
> @@ -70,6 +70,9 @@ static int lpfc_issue_els_flogi(struct l
>  				uint8_t);
>  static void lpfc_more_plogi(struct lpfc_hba *);
>  static void lpfc_more_adisc(struct lpfc_hba *);
> +static struct lpfc_iocbq *lpfc_prep_els_iocb(struct lpfc_hba * phba,
> +		uint8_t expectRsp, uint16_t cmdSize, uint8_t retry,
> +		struct lpfc_nodelist * ndlp, uint32_t elscmd);
>  
>  static int lpfc_max_els_tries = 3;
>  
> @@ -1408,7 +1411,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
>  	return (0);
>  }
>  
> -struct lpfc_iocbq *
> +static struct lpfc_iocbq *
>  lpfc_prep_els_iocb(struct lpfc_hba * phba,
>  		   uint8_t expectRsp,
>  		   uint16_t cmdSize,
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_els.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_fcp.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_fcp.c
> --- lpfcdriver-2.6-8.0.3/lpfc_fcp.c	2004-06-06 
> 18:48:59.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_fcp.c	2004-06-06 
> 10:24:00.194605832 +0200
> @@ -2266,51 +2266,3 @@ lpfc_do_dpc(void *p)
>  module_init(lpfc_init);
>  module_exit(lpfc_exit);
>  MODULE_LICENSE("GPL");
> -/*
> - * Note: PPC64 architecture has function descriptors,
> - * so insmod on 2.4 does not automatically export all symbols.
> - */
> -
> -EXPORT_SYMBOL(lpfc_assign_scsid);
> -EXPORT_SYMBOL(lpfc_block_requests);
> -EXPORT_SYMBOL(lpfc_build_scsi_cmd);
> -EXPORT_SYMBOL(lpfc_decode_firmware_rev);
> -EXPORT_SYMBOL(lpfc_disc_issue_rptlun);
> -EXPORT_SYMBOL(lpfc_drvr_name);
> -EXPORT_SYMBOL(lpfc_els_free_iocb);
> -EXPORT_SYMBOL(lpfc_find_lun);
> -EXPORT_SYMBOL(lpfc_findnode_did);
> -EXPORT_SYMBOL(lpfc_findnode_scsiid);
> -EXPORT_SYMBOL(lpfc_findnode_wwnn);
> -EXPORT_SYMBOL(lpfc_findnode_wwpn);
> -EXPORT_SYMBOL(lpfc_free_scsi_buf);
> -EXPORT_SYMBOL(lpfc_geportname);
> -EXPORT_SYMBOL(lpfc_get_hba_model_desc);
> -EXPORT_SYMBOL(lpfc_get_phba_by_inst);
> -EXPORT_SYMBOL(lpfc_get_scsi_buf);
> -EXPORT_SYMBOL(lpfc_hba_list);
> -EXPORT_SYMBOL(lpfc_init_link);
> -EXPORT_SYMBOL(lpfc_issue_els_adisc);
> -EXPORT_SYMBOL(lpfc_issue_els_logo);
> -EXPORT_SYMBOL(lpfc_issue_els_plogi);
> -EXPORT_SYMBOL(lpfc_loadtime);
> -EXPORT_SYMBOL(lpfc_mbuf_alloc);
> -EXPORT_SYMBOL(lpfc_mbuf_free);
> -EXPORT_SYMBOL(lpfc_nlp_bind);
> -EXPORT_SYMBOL(lpfc_nlp_mapped);
> -EXPORT_SYMBOL(lpfc_num_hba);
> -EXPORT_SYMBOL(lpfc_offline);
> -EXPORT_SYMBOL(lpfc_online);
> -EXPORT_SYMBOL(lpfc_page_free);
> -EXPORT_SYMBOL(lpfc_prep_els_iocb);
> -EXPORT_SYMBOL(lpfc_release_version);
> -EXPORT_SYMBOL(lpfc_scsi_lun_reset);
> -EXPORT_SYMBOL(lpfc_scsi_tgt_reset);
> -EXPORT_SYMBOL(lpfc_set_failmask);
> -EXPORT_SYMBOL(lpfc_sleep_ms);
> -EXPORT_SYMBOL(lpfc_sli_brdreset);
> -EXPORT_SYMBOL(lpfc_sli_issue_iocb_wait);
> -EXPORT_SYMBOL(lpfc_sli_issue_mbox);
> -EXPORT_SYMBOL(lpfc_sli_next_iotag);
> -EXPORT_SYMBOL(lpfc_sli_pcimem_bcopy);
> -EXPORT_SYMBOL(lpfc_unblock_requests);
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_fcp.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_hbadisc.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_hbadisc.c
> --- lpfcdriver-2.6-8.0.3/lpfc_hbadisc.c	2004-06-06 
> 18:49:00.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_hbadisc.c	2004-06-06 
> 10:37:04.846320640 +0200
> @@ -1677,7 +1677,7 @@ out:
>  }
>  
>  /* Search for a nodelist entry on a specific list */
> -struct lpfc_nodelist *
> +static struct lpfc_nodelist *
>  lpfc_findnode_scsiid(struct lpfc_hba * phba, uint32_t scsid)
>  {
>  	struct lpfc_nodelist *ndlp;
> @@ -1704,184 +1704,6 @@ lpfc_findnode_scsiid(struct lpfc_hba * p
>  
>  /* Search for a nodelist entry on a specific list */
>  struct lpfc_nodelist *
> -lpfc_findnode_wwnn(struct lpfc_hba * phba, uint32_t order,
> -		   struct lpfc_name * wwnn)
> -{
> -	struct lpfc_nodelist *ndlp, *next_ndlp;
> -	uint32_t data1;
> -	struct lpfc_bindlist *blp;
> -
> -	blp = 0;
> -	if (order & NLP_SEARCH_UNMAPPED) {
> -		list_for_each_entry_safe(ndlp, next_ndlp, 
> &phba->fc_nlpunmap_list,
> -					 nlp_listp) {
> -			if 
> (lpfc_geportname(&ndlp->nlp_nodename, wwnn) == 2) {
> -
> -				data1 = (((uint32_t) 
> ndlp->nlp_state << 24) |
> -					 ((uint32_t) 
> ndlp->nlp_xri << 16) |
> -					 ((uint32_t) 
> ndlp->nlp_type << 8) |
> -					 ((uint32_t) 
> ndlp->nlp_rpi & 0xff));
> -				/* FIND node DID unmapped */
> -				lpfc_printf_log(phba->brd_no, 
> &lpfc_msgBlk0910,
> -						lpfc_mes0910,
> -						
> lpfc_msgBlk0910.msgPreambleStr,
> -						(ulong) ndlp, 
> ndlp->nlp_DID,
> -						ndlp->nlp_flag, data1);
> -				if (order & NLP_SEARCH_DEQUE) {
> -					ndlp->nlp_flag &=
> -					    ~(NLP_UNMAPPED_LIST |
> -					      NLP_TGT_NO_SCSIID);
> -					phba->fc_unmap_cnt--;
> -					list_del(&ndlp->nlp_listp);
> -					phba->nport_event_cnt++;
> -				}
> -				return (ndlp);
> -			}
> -		}
> -	}
> -
> -	if (order & NLP_SEARCH_MAPPED) {
> -		list_for_each_entry_safe(ndlp, next_ndlp, 
> &phba->fc_nlpmap_list,
> -					 nlp_listp) {
> -			if 
> (lpfc_geportname(&ndlp->nlp_nodename, wwnn) == 2) {
> -
> -				data1 = (((uint32_t) 
> ndlp->nlp_state << 24) |
> -					 ((uint32_t) 
> ndlp->nlp_xri << 16) |
> -					 ((uint32_t) 
> ndlp->nlp_type << 8) |
> -					 ((uint32_t) 
> ndlp->nlp_rpi & 0xff));
> -				/* FIND node did mapped */
> -				lpfc_printf_log(phba->brd_no, 
> &lpfc_msgBlk0902,
> -						lpfc_mes0902,
> -						
> lpfc_msgBlk0902.msgPreambleStr,
> -						(ulong) ndlp, 
> ndlp->nlp_DID,
> -						ndlp->nlp_flag, data1);
> -				if (order & NLP_SEARCH_DEQUE) {
> -					ndlp->nlp_flag &= 
> ~NLP_MAPPED_LIST;
> -					phba->fc_map_cnt--;
> -					list_del(&ndlp->nlp_listp);
> -					phba->nport_event_cnt++;
> -
> -					/* Must call before binding is
> -					   removed */
> -					lpfc_set_failmask(phba, ndlp,
> -							  
LPFC_DEV_DISAPPEARED,
> -							  
LPFC_SET_BITMASK);
> -
> -					blp = ndlp->nlp_listp_bind;
> -					ndlp->nlp_listp_bind = 0;
> -					if (blp) {
> -						blp->nlp_Target =
> -						    ndlp->nlp_Target;
> -					}
> -					/* Keep Target and sid since
> -					 * LPFC_DEV_DISAPPEARED is a
> -					 * non-fatal error
> -					 */
> -					ndlp->nlp_flag &= 
> ~NLP_SEED_MASK;
> -				}
> -				if (blp) {
> -					lpfc_nlp_bind(phba, blp);
> -				}
> -				return (ndlp);
> -			}
> -		}
> -	}
> -
> -	/* no match found */
> -	return ((struct lpfc_nodelist *) 0);
> -}
> -
> -/* Search for a nodelist entry on a specific list */
> -struct lpfc_nodelist *
> -lpfc_findnode_wwpn(struct lpfc_hba * phba, uint32_t order,
> -		   struct lpfc_name * wwpn)
> -{
> -	struct lpfc_nodelist *ndlp, *next_ndlp;
> -	uint32_t data1;
> -	struct lpfc_bindlist *blp;
> -
> -	blp = 0;
> -	if (order & NLP_SEARCH_UNMAPPED) {
> -		list_for_each_entry_safe(ndlp, next_ndlp, 
> &phba->fc_nlpunmap_list,
> -					nlp_listp) {
> -			if 
> (lpfc_geportname(&ndlp->nlp_portname, wwpn) == 2) {
> -
> -				data1 = (((uint32_t) 
> ndlp->nlp_state << 24) |
> -					 ((uint32_t) 
> ndlp->nlp_xri << 16) |
> -					 ((uint32_t) 
> ndlp->nlp_type << 8) |
> -					 ((uint32_t) 
> ndlp->nlp_rpi & 0xff));
> -				/* FIND node DID unmapped */
> -				lpfc_printf_log(phba->brd_no, 
> &lpfc_msgBlk0911,
> -						lpfc_mes0911,
> -						
> lpfc_msgBlk0911.msgPreambleStr,
> -						(ulong) ndlp, 
> ndlp->nlp_DID,
> -						ndlp->nlp_flag, data1);
> -				if (order & NLP_SEARCH_DEQUE) {
> -					ndlp->nlp_flag &=
> -					    ~(NLP_UNMAPPED_LIST |
> -					      NLP_TGT_NO_SCSIID);
> -					phba->fc_unmap_cnt--;
> -					list_del(&ndlp->nlp_listp);
> -					phba->nport_event_cnt++;
> -				}
> -				return (ndlp);
> -			}
> -		}
> -	}
> -
> -	if (order & NLP_SEARCH_MAPPED) {
> -		list_for_each_entry_safe(ndlp, next_ndlp, 
> &phba->fc_nlpmap_list,
> -					nlp_listp) {
> -			if 
> (lpfc_geportname(&ndlp->nlp_portname, wwpn) == 2) {
> -
> -				data1 = (((uint32_t) 
> ndlp->nlp_state << 24) |
> -					 ((uint32_t) 
> ndlp->nlp_xri << 16) |
> -					 ((uint32_t) 
> ndlp->nlp_type << 8) |
> -					 ((uint32_t) 
> ndlp->nlp_rpi & 0xff));
> -				/* FIND node DID mapped */
> -				lpfc_printf_log(phba->brd_no, 
> &lpfc_msgBlk0901,
> -						lpfc_mes0901,
> -						
> lpfc_msgBlk0901.msgPreambleStr,
> -						(ulong) ndlp, 
> ndlp->nlp_DID,
> -						ndlp->nlp_flag, data1);
> -				if (order & NLP_SEARCH_DEQUE) {
> -					ndlp->nlp_flag &= 
> ~NLP_MAPPED_LIST;
> -					phba->fc_map_cnt--;
> -					list_del(&ndlp->nlp_listp);
> -					phba->nport_event_cnt++;
> -
> -					/* Must call before binding is
> -					   removed */
> -					lpfc_set_failmask(phba, ndlp,
> -							  
LPFC_DEV_DISAPPEARED,
> -							  
LPFC_SET_BITMASK);
> -
> -					blp = ndlp->nlp_listp_bind;
> -					ndlp->nlp_listp_bind = 0;
> -					if (blp) {
> -						blp->nlp_Target =
> -						    ndlp->nlp_Target;
> -					}
> -					/* Keep Target and sid since
> -					 * LPFC_DEV_DISAPPEARED is a
> -					 * non-fatal error
> -					 */
> -					ndlp->nlp_flag &= 
> ~NLP_SEED_MASK;
> -				}
> -				if (blp) {
> -					lpfc_nlp_bind(phba, blp);
> -				}
> -				return (ndlp);
> -			}
> -		}
> -	}
> -
> -	/* no match found */
> -	return ((struct lpfc_nodelist *) 0);
> -}
> -
> -/* Search for a nodelist entry on a specific list */
> -struct lpfc_nodelist *
>  lpfc_findnode_did(struct lpfc_hba * phba, uint32_t order, 
> uint32_t did)
>  {
>  	struct lpfc_nodelist *ndlp, *next_ndlp;
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_hbadisc.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_init.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_init.c
> --- lpfcdriver-2.6-8.0.3/lpfc_init.c	2004-06-06 
> 18:49:00.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_init.c	2004-06-06 
> 10:33:32.597587352 +0200
> @@ -47,6 +47,8 @@ static int lpfc_post_rcv_buf(struct lpfc
>  static void lpfc_establish_link_tmo(unsigned long ptr);
>  static int lpfc_check_for_vpd = 1;
>  static int lpfc_rdrev_wd30 = 0;
> +static int lpfc_online(struct lpfc_hba * phba);
> +static int lpfc_offline(struct lpfc_hba * phba);
>  
>  
>  
> /*************************************************************
> ***********/
> @@ -1152,7 +1154,7 @@ lpfc_establish_link_tmo(unsigned long pt
>  	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
>  }
>  
> -int
> +static int
>  lpfc_online(struct lpfc_hba * phba)
>  {
>  	uint32_t timeout;
> @@ -1198,7 +1200,7 @@ lpfc_online(struct lpfc_hba * phba)
>  	return (0);
>  }
>  
> -int
> +static int
>  lpfc_offline(struct lpfc_hba * phba)
>  {
>  	struct lpfc_sli_ring *pring;
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_init.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_logmsg.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_logmsg.c
> --- lpfcdriver-2.6-8.0.3/lpfc_logmsg.c	2004-06-06 
> 18:49:00.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_logmsg.c	2004-06-06 
> 10:40:54.240447432 +0200
> @@ -3483,48 +3483,6 @@ msgLogDef lpfc_msgBlk0900 = {
>  };
>  
>  /*
> -msgName: lpfc_mes0901
> -message:  FIND node DID mapped
> -descript: The driver is searching for a node table entry, on the 
> -          mapped node list, based on DID.
> -data:     (1) nlp (2) nlp_DID (3) nlp_flag (4) data1
> -severity: Information
> -log:      LOG_NODE verbose
> -action:   No action needed, informational
> -*/
> -char lpfc_mes0901[] = "%sFIND node DID mapped Data: x%x x%x x%x x%x";
> -msgLogDef lpfc_msgBlk0901 = {
> -	LPFC_LOG_MSG_ND_0901,
> -	lpfc_mes0901,
> -	lpfc_msgPreambleNDi,
> -	LPFC_MSG_OPUT_GLOB_CTRL,
> -	LPFC_LOG_MSG_TYPE_INFO,
> -	LOG_NODE,
> -	ERRID_LOG_UNEXPECT_EVENT
> -};
> -
> -/*
> -msgName: lpfc_mes0902
> -message:  FIND node DID mapped
> -descript: The driver is searching for a node table entry, on the 
> -          mapped node list, based on DID.
> -data:     (1) nlp (2) nlp_DID (3) nlp_flag (4) data1
> -severity: Information
> -log:      LOG_NODE verbose
> -action:   No action needed, informational
> -*/
> -char lpfc_mes0902[] = "%sFIND node DID mapped Data: x%x x%x x%x x%x";
> -msgLogDef lpfc_msgBlk0902 = {
> -	LPFC_LOG_MSG_ND_0902,
> -	lpfc_mes0902,
> -	lpfc_msgPreambleNDi,
> -	LPFC_MSG_OPUT_GLOB_CTRL,
> -	LPFC_LOG_MSG_TYPE_INFO,
> -	LOG_NODE,
> -	ERRID_LOG_UNEXPECT_EVENT
> -};
> -
> -/*
>  msgName: lpfc_mes0903
>  message:  Add scsiid <sid> to BIND list 
>  descript: The driver is putting the node table entry on the 
> binding list.
> @@ -3646,48 +3604,6 @@ msgLogDef lpfc_msgBlk0908 = {
>  };
>  
>  /*
> -msgName: lpfc_mes0910
> -message:  FIND node DID unmapped
> -descript: The driver is searching for a node table entry, on the 
> -          unmapped node list, based on DID.
> -data:     (1) nlp (2) nlp_DID (3) nlp_flag (4) data1
> -severity: Information
> -log:      LOG_NODE verbose
> -action:   No action needed, informational
> -*/
> -char lpfc_mes0910[] = "%sFIND node DID unmapped Data: x%x 
> x%x x%x x%x";
> -msgLogDef lpfc_msgBlk0910 = {
> -	LPFC_LOG_MSG_ND_0910,
> -	lpfc_mes0910,
> -	lpfc_msgPreambleNDi,
> -	LPFC_MSG_OPUT_GLOB_CTRL,
> -	LPFC_LOG_MSG_TYPE_INFO,
> -	LOG_NODE,
> -	ERRID_LOG_UNEXPECT_EVENT
> -};
> -
> -/*
> -msgName: lpfc_mes0911
> -message:  FIND node DID unmapped
> -descript: The driver is searching for a node table entry, on the 
> -          unmapped node list, based on DID.
> -data:     (1) nlp (2) nlp_DID (3) nlp_flag (4) data1
> -severity: Information
> -log:      LOG_NODE verbose
> -action:   No action needed, informational
> -*/
> -char lpfc_mes0911[] = "%sFIND node DID unmapped Data: x%x 
> x%x x%x x%x";
> -msgLogDef lpfc_msgBlk0911 = {
> -	LPFC_LOG_MSG_ND_0911,
> -	lpfc_mes0911,
> -	lpfc_msgPreambleNDi,
> -	LPFC_MSG_OPUT_GLOB_CTRL,
> -	LPFC_LOG_MSG_TYPE_INFO,
> -	LOG_NODE,
> -	ERRID_LOG_UNEXPECT_EVENT
> -};
> -
> -/*
>  msgName: lpfc_mes0929
>  message:  FIND node DID unmapped
>  descript: The driver is searching for a node table entry, on the 
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_logmsg.o
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_mbox.o
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_mem.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_nportdisc.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_nportdisc.c
> --- lpfcdriver-2.6-8.0.3/lpfc_nportdisc.c	2004-06-06 
> 18:49:00.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_nportdisc.c	2004-06-06 
> 10:31:59.117798440 +0200
> @@ -44,6 +44,8 @@
>  extern uint8_t lpfcAlpaArray[];
>  
>  int lpfc_geportname(struct lpfc_name *, struct lpfc_name *);
> +static struct lpfc_bindlist *lpfc_assign_scsid(struct 
> lpfc_hba * phba,
> +		struct lpfc_nodelist * ndlp, int prev_flag);
>  
>  
>  static int
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_nportdisc.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_scsiport.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_scsiport.c
> --- lpfcdriver-2.6-8.0.3/lpfc_scsiport.c	2004-06-06 
> 18:49:00.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_scsiport.c	2004-06-06 
> 10:35:27.202164808 +0200
> @@ -518,7 +518,7 @@ lpfc_scsi_cmd_abort(struct lpfc_hba * ph
>  
>  }
>  
> -int
> +static int
>  lpfc_scsi_lun_reset(LPFC_SCSI_BUF_t * lpfc_cmd, 
>  		    struct lpfc_hba *phba, uint32_t flag)
>  {
> @@ -623,7 +623,7 @@ lpfc_scsi_lun_reset(LPFC_SCSI_BUF_t * lp
>  
>  }
>  
> -int
> +static int
>  lpfc_scsi_tgt_reset(LPFC_SCSI_BUF_t * lpfc_cmd,
>  		    struct lpfc_hba * phba, uint32_t flag)
>  {
> Only in lpfcdriver-2.6-8.0.3.hch/: lpfc_scsiport.o
> diff -urp lpfcdriver-2.6-8.0.3/lpfc_sli.c 
> lpfcdriver-2.6-8.0.3.hch/lpfc_sli.c
> --- lpfcdriver-2.6-8.0.3/lpfc_sli.c	2004-06-06 
> 18:49:00.000000000 +0200
> +++ lpfcdriver-2.6-8.0.3.hch/lpfc_sli.c	2004-06-06 
> 10:34:53.527284168 +0200
> @@ -66,11 +66,10 @@ static struct lpfc_iocbq *lpfc_search_tx
>  static DMABUF_t *lpfc_sli_ringpostbuf_search(struct lpfc_hba *,
>  					     struct 
> lpfc_sli_ring *, dma_addr_t,
>  					     int);
> -static void lpfc_sli_wake_iocb_wait(struct lpfc_hba *, 
> struct lpfc_iocbq *,
> -				    struct lpfc_iocbq *);
>  static int lpfc_sli_abort_iocb_ring(struct lpfc_hba *, 
> struct lpfc_sli_ring *,
>  				    uint32_t);
>  static int lpfc_sli_resume_iocb(struct lpfc_hba *, struct 
> lpfc_sli_ring *);
> +static int lpfc_sli_brdreset(struct lpfc_hba * phba);
>  
>  /*
>   * Define macro to log: Mailbox command x%x cannot issue Data
> @@ -2243,7 +2242,7 @@ lpfc_sli_resume_iocb(struct lpfc_hba * p
>  	return (portCmdGet);
>  }
>  
> -int
> +static int
>  lpfc_sli_brdreset(struct lpfc_hba * phba)
>  {
>  	MAILBOX_t *swpmb;
> @@ -3357,103 +3356,6 @@ lpfc_sli_abort_iocb_tgt(struct lpfc_hba 
>  }
>  
>  void
> -lpfc_sli_wake_iocb_wait(struct lpfc_hba * phba,
> -			struct lpfc_iocbq * queue1, struct 
> lpfc_iocbq * queue2)
> -{
> -	wait_queue_head_t *pdone_q;
> -
> -	queue1->iocb_flag |= LPFC_IO_WAIT;
> -	if (queue1->context2 && queue2)
> -		memcpy(queue1->context2, queue2, sizeof (struct 
> lpfc_iocbq));
> -
> -	/* 
> -	 * If pdone_q is empty, the waiter gave up and returned and this
> -	 * call has nothing to do.
> -	 */
> -	pdone_q = queue1->context_un.hipri_wait_queue;
> -	if (pdone_q) {
> -		wake_up(pdone_q);
> -	}
> -
> -	return;
> -}
> -
> -int
> -lpfc_sli_issue_iocb_wait(struct lpfc_hba * phba,
> -			 struct lpfc_sli_ring * pring,
> -			 struct lpfc_iocbq * piocb,
> -			 uint32_t flag,
> -			 struct lpfc_iocbq * prspiocbq, 
> uint32_t timeout)
> -{
> -	DECLARE_WAIT_QUEUE_HEAD(done_q);
> -	DECLARE_WAITQUEUE(wq_entry, current);
> -	uint32_t timeleft = 0;
> -	int retval;
> -
> -	/* The caller must leave context1 empty for the driver. */
> -	if (piocb->context_un.hipri_wait_queue != 0) {
> -		return (IOCB_ERROR);
> -	}
> -	/* If the caller has provided a response iocbq buffer, 
> then context2 
> -	 * is NULL or its an error.
> -	 */
> -	if (prspiocbq) {
> -		if (piocb->context2) {
> -			return (IOCB_ERROR);
> -		}
> -		piocb->context2 = prspiocbq;
> -	}
> -
> -	/* setup wake call as IOCB callback */
> -	piocb->iocb_cmpl = lpfc_sli_wake_iocb_wait;
> -	/* setup context field to pass wait_queue pointer to 
> wake function  */
> -	piocb->context_un.hipri_wait_queue = &done_q;
> -
> -	/* start to sleep before we wait, to avoid races */
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> -	add_wait_queue(&done_q, &wq_entry);
> -
> -	/* now issue the command */
> -	retval = lpfc_sli_issue_iocb(phba, pring, piocb, flag);
> -	if ((retval == IOCB_SUCCESS) ||
> -	    ((!(flag & SLI_IOCB_RET_IOCB)) && retval == IOCB_BUSY)) {
> -
> -		/* Give up thread time and wait for the iocb to 
> complete or for
> -		 * the alloted time to expire.
> -		 */
> -		timeleft = schedule_timeout(timeout * HZ);
> -
> -		piocb->context_un.hipri_wait_queue = 0;	
> -		piocb->iocb_cmpl                   = 0;
> -		if (piocb->context2 == prspiocbq)
> -			piocb->context2 = 0;
> -
> -		/* Catch the error cases.  A timeleft of zero 
> is an error since
> -		 * the iocb should have completed.  The 
> iocb_flag not have value
> -		 * LPFC_IO_WAIT is also an error since the 
> wakeup callback sets
> -		 * this flag when it runs.  Handle each.
> -		 *
> -
> -		 */
> -		if ((timeleft == 0) || !(piocb->iocb_flag & 
> LPFC_IO_WAIT)) {
> -			if (timeleft == 0) {
> -				printk(KERN_WARNING "lpfc 
> driver detected iocb "
> -				       "Timeout!\n");
> -				retval = IOCB_TIMEDOUT;
> -			} else {
> -				printk(KERN_WARNING "lpfc 
> driver detected iocb "
> -				       "flag = 0x%X\n", 
> piocb->iocb_flag);
> -				retval = IOCB_TIMEDOUT;
> -			}
> -		}
> -	}
> -
> -	remove_wait_queue(&done_q, &wq_entry);
> -	set_current_state(TASK_RUNNING);
> -	return retval;
> -}
> -
> -void
>  lpfc_sli_wake_iocb_high_priority(struct lpfc_hba * phba,
>  				 struct lpfc_iocbq * queue1,
>  				 struct lpfc_iocbq * queue2)
> 
