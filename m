From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/10] zfcp: fix fc_host port_type with NPIV
Date: Thu, 11 Aug 2016 13:19:22 +0200
Message-ID: <68b6196f-4c93-2062-c796-95034a6fe981@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-2-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470846653-90691-2-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 30+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> For an NPIV-enabled FCP device, zfcp can erroneously show
> "NPort (fabric via point-to-point)" instead of "NPIV VPORT"
> for the port_type sysfs attribute of the corresponding
> fc_host.
> s390-tools that can be affected are dbginfo.sh and ziomon.
> 
> zfcp_fsf_exchange_config_evaluate() ignores
> fsf_qtcb_bottom_config.connection_features indicating NPIV
> and only sets fc_host_port_type to FC_PORTTYPE_NPORT if
> fsf_qtcb_bottom_config.fc_topology is FSF_TOPO_FABRIC.
> 
> Only the independent zfcp_fsf_exchange_port_evaluate()
> evaluates connection_features to overwrite fc_host_port_type
> to FC_PORTTYPE_NPIV in case of NPIV.
> Code was introduced with upstream kernel 2.6.30
> commit 0282985da5923fa6365adcc1a1586ae0c13c1617
> ("[SCSI] zfcp: Report fc_host_port_type as NPIV").
> 
> This works during FCP device recovery (such as set online)
> because it performs FSF_QTCB_EXCHANGE_CONFIG_DATA followed by
> FSF_QTCB_EXCHANGE_PORT_DATA in sequence.
> 
> However, the zfcp-specific scsi host sysfs attributes
> "requests", "megabytes", or "seconds_active" trigger only
> zfcp_fsf_exchange_config_evaluate() resetting fc_host
> port_type to FC_PORTTYPE_NPORT despite NPIV.
> 
> The zfcp-specific scsi host sysfs attribute "utilization"
> triggers only zfcp_fsf_exchange_port_evaluate() correcting
> the fc_host port_type again in case of NPIV.
> 
> Evaluate fsf_qtcb_bottom_config.connection_features
> in zfcp_fsf_exchange_config_evaluate() where it belongs to.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: 0282985da592 ("[SCSI] zfcp: Report fc_host_port_type as NPIV")
> Cc: <stable@vger.kernel.org> #2.6.30+
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
