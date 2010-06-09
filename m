From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: libfc fc_rport_recv_prli_req() changes for v2.6.35-rc2
Date: Wed, 09 Jun 2010 15:23:07 -0700
Message-ID: <4C10144B.9040703@cisco.com>
References: <1276120786.18353.89.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:37866 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab0FIWXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2010 18:23:22 -0400
In-Reply-To: <1276120786.18353.89.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: openfcoe-devel <devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Love, Robert W" <robert.w.love@intel.com>

On 6/9/10 2:59 PM, Nicholas A. Bellinger wrote:
> Greetings Joe,
>
> While doing a pull recently for v2.6.35-rc2, I ran into a merge conflict
> below in drivers/scsi/libfc/fc_rport.c:fc_rport_recv_pril_req()
> with the original PLOGI driven target provider hooks changes that I have
> been including into the lio-core-2.6.git tree for tcm_fc.
>
>> From taking a quick look, I assume that active and passing prov->prli()
> calls need to appear under the new roles assignment, namely under:
>
>        if (fcp_parm&  FCP_SPPF_TARG_FCN)
>                roles |= FC_RPORT_ROLE_FCP_TARGET;
>
> for the upstream e44a21b726 commit.  Is there anything else that should
> be taken into consideration to get this running again..?

Most of the code in the HEAD version is right.

Just add the two lines initializing the roles to unknown
to the version above the ==== separator and then keep that version.

The provider prli() functions will take care of the roles.

	Cheers,
	Joe

> Best,
>
> --nab
>
> <<<<<<<  HEAD
>
>          /*
>           * Go through all the service parameter pages and build
>           * response.  If plen indicates longer SPP than standard,
>           * use that.  The entire response has been pre-cleared above.
>           */
>          spp =&pp->spp;
>          mutex_lock(&fc_prov_mutex);
>          while (len>= plen) {
>                  spp->spp_type = rspp->spp_type;
>                  spp->spp_type_ext = rspp->spp_type_ext;
>                  resp = 0;
>
>                  if (rspp->spp_type<  FC_FC4_PROV_SIZE) {
>                          prov = fc_active_prov[rspp->spp_type];
>                          if (prov)
>                                  resp = prov->prli(rdata, plen, rspp, spp);
>                          prov = fc_passive_prov[rspp->spp_type];
>                          if (prov) {
>                                  passive = prov->prli(rdata, plen, rspp, spp);
>                                  if (!resp || passive == FC_SPP_RESP_ACK)
>                                          resp = passive;
>                          }
>                  }
>                  if (!resp) {
>                          if (spp->spp_flags&  FC_SPP_EST_IMG_PAIR)
>                                  resp |= FC_SPP_RESP_CONF;
>                          else
>                                  resp |= FC_SPP_RESP_INVL;
>                  }
>                  spp->spp_flags |= resp;
>                  len -= plen;
>                  rspp = (struct fc_els_spp *)((char *)rspp + plen);
>                  spp = (struct fc_els_spp *)((char *)spp + plen);
>          }
>          mutex_unlock(&fc_prov_mutex);
>
>          /*
>           * Send LS_ACC.  If this fails, the originator should retry.
>           */
>          f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
>          f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
>          ep = fc_seq_exch(sp);
>          fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
>                         FC_TYPE_ELS, f_ctl, 0);
>          lport->tt.seq_send(lport, sp, fp);
>
> =======
>
>          /* reinitialize remote port roles */
>          rdata->ids.roles = FC_RPORT_ROLE_UNKNOWN;

Add the above two lines to the HEAD version.

>          /*
>           * Go through all the service parameter pages and build
>           * response.  If plen indicates longer SPP than standard,
>           * use that.  The entire response has been pre-cleared above.
>           */
>          spp =&pp->spp;
>          while (len>= plen) {
>                  spp->spp_type = rspp->spp_type;
>                  spp->spp_type_ext = rspp->spp_type_ext;
>                  spp->spp_flags = rspp->spp_flags&  FC_SPP_EST_IMG_PAIR;
>                  resp = FC_SPP_RESP_ACK;
>
>                  switch (rspp->spp_type) {
>                  case 0: /* common to all FC-4 types */
>                          break;
>                  case FC_TYPE_FCP:
>                          fcp_parm = ntohl(rspp->spp_params);
>                          if (fcp_parm&  FCP_SPPF_RETRY)
>                                  rdata->flags |= FC_RP_FLAGS_RETRY;
>                          rdata->supported_classes = FC_COS_CLASS3;
>                          if (fcp_parm&  FCP_SPPF_INIT_FCN)
>                                  roles |= FC_RPORT_ROLE_FCP_INITIATOR;
>                          if (fcp_parm&  FCP_SPPF_TARG_FCN)
>                                  roles |= FC_RPORT_ROLE_FCP_TARGET;
>                          rdata->ids.roles = roles;
>
>                          spp->spp_params = htonl(lport->service_params);
>                          break;
>                  default:
>                          resp = FC_SPP_RESP_INVL;
>                          break;
>                  }
>                  spp->spp_flags |= resp;
>                  len -= plen;
>                  rspp = (struct fc_els_spp *)((char *)rspp + plen);
>                  spp = (struct fc_els_spp *)((char *)spp + plen);
>          }
>
>          /*
>           * Send LS_ACC.  If this fails, the originator should retry.
>           */
>          f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
>          f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
>          ep = fc_seq_exch(sp);
>          fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
>                         FC_TYPE_ELS, f_ctl, 0);
>          lport->tt.seq_send(lport, sp, fp);
>
>>>>>>>> e44a21b7268a022c7749f521c06214145bd161e4
>

