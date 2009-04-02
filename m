From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: Proposal to add sysfs attributes for FCoE in FC Transport layer
Date: Wed, 1 Apr 2009 18:01:41 -0700
Message-ID: <3085D686-5D82-45E4-9E1D-038F13453A7F@qlogic.com>
References: <9F784EDD-BC14-4113-B7F2-1E5EBC17B65F@qlogic.com> <49D37349.3070202@emulex.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14269 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZDBBBn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 21:01:43 -0400
In-Reply-To: <49D37349.3070202@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Marcus Barrow <marcus.barrow@qlogic.com>, David Wagner <david.wagner@qlogic.com>


On Apr 1, 2009, at 6:59 AM, James Smart wrote:

> The largest issue I have is - what attributes are really fc/fcoe  
> specific ?
> DCBX and PFC are arguably NIC-related parameters and have no  
> business being
> under the fc transport.  Additionally, whatever we pick, we had  
> better put
> the same or like parameters with lib_fcoe-supporting adapters in the  
> same
> place.
>
> This is very muddy as some adapters will want present a fc/scsi  
> function
> only, hiding the nic completely; others may present a nic function and
> an fcoe function, and physically share the nic; while others will have
> only the nic and a bunch of software, or a nic with super-features for
> fcoe.  What object belongs where for what attribute ?

I agree. With various ways the adapters can support the FCoE  
functionalities, it's big issue to identify FC and FCoE specific  
attributes.

I felt there should be separate statistics for those adapters where  
both FCoE and NIC functions are exposed, but use only the FCoE  
function and FC transport layer similar to other FC adapters. Some of  
the existing statistics does not give complete picture for such  
adapters and hence needed more additions. Though adding few of the MAC  
statistics gives better picture, but are totally non-FC specific and a  
question whether to be supported in FC transport layer? But without  
NIC in this case, it needs some place holder and I thought statistics  
under FCoE may be a better place.
>
>
> Another thing that should be brought up is the presentation model when
> there are multiple FCF's that an FCOE adapter can talk to. I'm a fan  
> of
> having a new fc_host for every new *initiator* context on a fabric.
> Meaning, there's a fc_host for each N_Port_Id on each fabric (which is
> what we have been doing for NPIV and VSANs). Mean an FCOE port, which
> sees multiple FCFs, or contacts the same FCF on different vlans (which
> map to different VSANs) need to be separate fc_hosts.  Additionally,  
> we
> should also consider a bit, what and how do we manage when there are
> multiple FCF's into the same fabric.  (Note: this pushes again on why
> isn't FC a "bus" rather than the top thing, usually a pci function,  
> must
> be a scsi_host ?).
>
> A few more comments inline...

I agree for having a separate host for each N_Port_Id. This gives  
better distinction and flexibility with multiple FCF support.
>
>
> -- james s
>
> Giridhar Malavali wrote:
>> Hi SCSI mailing list,
>>
>> 	I'd like to propose following additions to sysfs to export  
>> statistics
>> of FCoE host bus adapters.
>> The additions can be broadly divided into capabilities of FCoE HBA
>> adapter and its statistics.
>> I am thinking of extending HBA specific informations inside the
>> fc_host(/sys/class/fc_host/hostX) and make a seperate
>> attribute_group(/sys/class/fc_host/hostx/fcoe_statistics/) for fcoe
>> statistics.
>
> I disagree with the "statistics" in the name unless it truly is a
> statistic.  I do agree with, for fcoe-specific fc information, a
> subdirectory (or attribute group) that is under the fc_host.
> (such as /sys/class/fc_host/hostX/fcoe and if there are fcoe-specific
> statistics, in a directory /sys/class/fc_host/hostX/fcoe/statistics).
>
The various different FC link errors (LESB) in the fc_host/statistics  
can be mapped to counter parts in MAC. I saw a proposal(09-204v0) for  
addition of these statistics to FC-BB-5 in T11, by Roger Hathorn. I  
think those MAC statistics can be used as FCoE specific statistics.

>>
>> FCoE HBA specific information
>>
>> 1) enode_mac_address		/* Factory programmed MAC address */
>> 2) vn_port_mac_address;     	/* Current programmed MAC address */
>> 3) fcf_mac_address;			/* FCF mac address */
>> 4) vlan_id:					/* Local VLAN ID */
>> 5) mac_addressing_model	/* Whether SPMA or FPMA */
>
> These make a lot of sense to go into the .../hostX/fcoe directory.  
> As we
> look closer, we'll probably extend this list.
>
>> Current DCBX parameter details:
>>
>> PGID (Priority group ID)
>>
>> 1) pgid_priority_group_0;       /* Priority group ID of priority  
>> group
>> 0 */
>> 2) pgid_priority_group_1;       /* Priority group ID of priority  
>> group
>> 1 */
>> 3) pgid_priority_group_2;       /* Priority group ID of priority  
>> group
>> 2 */
>> 4) pgid_priority_group_3;       /* Priority group ID of priority  
>> group
>> 3 */
>> 5) pgid_priority_group_4;       /* Priority group ID of priority  
>> group
>> 4 */
>> 6) pgid_priority_group_5;       /* Priority group ID of priority  
>> group
>> 5 */
>> 7) pgid_priority_group_6;       /* Priority group ID of priority  
>> group
>> 6 */
>> 8) pgid_priority_group_7;       /* Priority group ID of priority  
>> group
>> 7 */
>>
>> Bandwidth assignment per priority group
>>
>> 1) priority_group_0_bw_percentage; 	/* Priority group 0 bandwidth
>> percentage */
>> 2) priority_group_1_bw_percentage; 	/* Priority group 1 bandwidth
>> percentage */
>> 3) priority_group_2_bw_percentage; 	/* Priority group 2 bandwidth
>> percentage */
>> 4) priority_group_3_bw_percentage; 	/* Priority group 3 bandwidth
>> percentage */
>> 5) priority_group_4_bw_percentage; 	/* Priority group 4 bandwidth
>> percentage */
>> 6) priority_group_5_bw_percentage; 	/* Priority group 5 bandwidth
>> percentage */
>> 7) priority_group_6_bw_percentage; 	/* Priority group 6 bandwidth
>> percentage */
>> 8) priority_group_7_bw_percentage; 	/* Priority group 7 bandwidth
>> percentage */
>>
>> Priority based flow control (PFC)
>>
>> 1) pfc_enabled_priority_0		/* Flow control is enabled in both
>> direction for priority 0 */
>> 2) pfc_enabled_priority_2		/* Flow control is enabled in both
>> direction for priority 1 */
>> 3) pfc_enabled_priority_3		/* Flow control is enabled in both
>> direction for priority 2 */
>> 4) pfc_enabled_priority_4		/* Flow control is enabled in both
>> direction for priority 3 */
>> 5) pfc_enabled_priority_5		/* Flow control is enabled in both
>> direction for priority 4 */
>> 6) pfc_enabled_priority_6		/* Flow control is enabled in both
>> direction for priority 5 */
>> 7) pfc_enabled_priority_7		/* Flow control is enabled in both
>> direction for priority 6 */
>> 8) pfc_enabled_priority_8		/* Flow control is enabled in both
>> direction for priority 7 */
>>
>
> As mentioned, I have heartburn with this under the fc_host.
>
> But if there is no NIC - where should it go ?
>


>
>> Statistics:
>>
>> 1) fcoe_tx_frames;               		/* number of FCoE transmit  
>> frames */
>> 2) fcoe_tx_words;				/* number of tx words */	
>> 3) fcoe_rx_frames;                		/* number of FCoE receive  
>> frames */
>> 4) fcoe_rx_words;				/* number of rx words */	
>> 5) fcoe_rx_drop_frames;                	/* number of FCoE dropped
>> receive frames */
>
> What's the difference between these and the normal FC statistics ?


They are the same. I though of keeping it for comparison reasons. We  
can keep it in case of separate fcoe group in fc_host or can be removed.
>
>
>> 6) fcoe_tx_pause_pkts;                 	/* number of FCoE transmit
>> PAUSE packets */
>> 7) fcoe_rx_pause_pkts;                 	/* number of FCoE receive
>> PAUSE packets */
>> 8) fcoe_tx_cbfc_pause_frames_0;        	/* number of class based flow
>> control transmit PAUSE frames on PG 0 */
>> 9) fcoe_tx_cbfc_pause_frames_1;        	/* number of class based flow
>> control transmit PAUSE frames on PG 1 */
>> 10) fcoe_tx_cbfc_pause_frames_2;       	/* number of class based flow
>> control transmit PAUSE frames on PG 2 */
>> 11) fcoe_tx_cbfc_pause_frames_3;       	/* number of class based flow
>> control transmit PAUSE frames on PG 3 */
>> 12) fcoe_tx_cbfc_pause_frames_4;       	/* number of class based flow
>> control transmit PAUSE frames on PG 4 */
>> 13) fcoe_tx_cbfc_pause_frames_5;       	/* number of class based flow
>> control transmit PAUSE frames on PG 5 */
>> 14) fcoe_tx_cbfc_pause_frames_6;       	/* number of class based flow
>> control transmit PAUSE frames on PG 6 */
>> 15) fcoe_tx_cbfc_pause_frames_7;       	/* number of class based flow
>> control transmit PAUSE frames on PG 7 */
>> 16) fcoe_rx_cbfc_pause_frames_0;       	/* number of class based flow
>> control recieve PAUSE frames on PG 0 */
>> 17) fcoe_rx_cbfc_pause_frames_1;       	/* number of class based flow
>> control recieve PAUSE frames on PG 1 */
>> 18) fcoe_rx_cbfc_pause_frames_2;       	/* number of class based flow
>> control recieve PAUSE frames on PG 2 */
>> 19) fcoe_rx_cbfc_pause_frames_3;       	/* number of class based flow
>> control recieve PAUSE frames on PG 3 */
>> 20) fcoe_rx_cbfc_pause_frames_4;       	/* number of class based flow
>> control recieve PAUSE frames on PG 4 */
>> 21) fcoe_rx_cbfc_pause_frames_5;       	/* number of class based flow
>> control recieve PAUSE frames on PG 5 */
>> 22) fcoe_rx_cbfc_pause_frames_6;       	/* number of class based flow
>> control recieve PAUSE frames on PG 6 */
>> 23) fcoe_rx_cbfc_pause_frames_7;       	/* number of class based flow
>> control recieve PAUSE frames on PG 7 */
>> 24) fcoe_tx_priority_pkts_0;            		/* number of priority 0
>> based transmit packets */
>> 25) fcoe_tx_priority_pkts_1;            		/* number of priority 1
>> based transmit packets */
>> 26) fcoe_tx_priority_pkts_2;            		/* number of priority 2
>> based transmit packets */
>> 27) fcoe_tx_priority_pkts_3;            		/* number of priority 3
>> based transmit packets */
>> 28) fcoe_tx_priority_pkts_4;            		/* number of priority 4
>> based transmit packets */
>> 29) fcoe_tx_priority_pkts_5;           		/* number of priority 5  
>> based
>> transmit packets */
>> 30) fcoe_tx_priority_pkts_6;            		/* number of priority 6
>> based transmit packets */
>> 31) fcoe_tx_priority_pkts_7;            		/* number of priority 7
>> based transmit packets */
>> 32) fcoe_rx_priority_pkts_0;            		/* number of priority 0
>> based received packets */
>> 33) fcoe_rx_priority_pkts_1;            		/* number of priority 1
>> based received packets */
>> 34) fcoe_rx_priority_pkts_2;            		/* number of priority 2
>> based received packets */
>> 35) fcoe_rx_priority_pkts_3;            		/* number of priority 3
>> based received packets */
>> 36) fcoe_rx_priority_pkts_4;            		/* number of priority 4
>> based received packets */
>> 37) fcoe_rx_priority_pkts_5;            		/* number of priority 5
>> based received packets */
>> 38) fcoe_rx_priority_pkts_6;            		/* number of priority 6
>> based received packets */
>> 39) fcoe_rx_priority_pkts_7;            		/* number of priority 7
>> based received packets */
>
> Aren't these really NIC-level statistics too ?   what makes them so  
> fcoe-ish ?

Yes, they are NIC statistics, but once again I thought of having these  
for better clarity from FCoE protocol perspective.
Since there is no specific place holder for this, I thought of adding  
this in FC transport.
>
>
>>
>> Thanks,
>> Giridhar Malavali
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

