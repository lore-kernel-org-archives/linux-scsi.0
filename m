From: "Mark Grimes" <markcgrimes@gmail.com>
Subject: Code error in mptsas.c ?
Date: Thu, 24 Jan 2008 15:37:02 -0800
Message-ID: <ae2ced240801241537s51dc57c0u52aea157f98fbbca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.246]:31738 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755494AbYAXXhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 18:37:05 -0500
Received: by hs-out-2122.google.com with SMTP id 54so387539hsz.5
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jan 2008 15:37:04 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In mptsas.c there are two functions mptsas_find_phyinfo_by_target and
mptsas_find_phyinfo_by_sas
_address.  Below is the 'by_target' function.  It appears the intent
is to break out of the search when the matching phy_info is found.
However, the 'break' statement will only move to the next 'list' entry
and continue the search.  The 'by_sas_address' function appears to
have the same flaw.  I believe the addition of "if (phy_info) break;"
outside the 'for' loop would correct the functionality.

Can you confirm this?

static struct mptsas_phyinfo *
mptsas_find_phyinfo_by_target(MPT_ADAPTER *ioc, u32 id)
{
        struct mptsas_portinfo *port_info;
        struct mptsas_phyinfo *phy_info = NULL;
        int i;

        mutex_lock(&ioc->sas_topology_mutex);
        list_for_each_entry(port_info, &ioc->sas_topology, list) {
                for (i = 0; i < port_info->num_phys; i++) {
                        if (port_info->phy_info[i].attached.id != id)
                                continue;
                        if (!mptsas_is_end_device(
                                &port_info->phy_info[i].attached))
                                continue;
                        phy_info = &port_info->phy_info[i];
                        break;
                }
        }
        mutex_unlock(&ioc->sas_topology_mutex);
        return phy_info;
}

-Mark G
